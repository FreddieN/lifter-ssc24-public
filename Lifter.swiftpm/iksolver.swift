//
//  iksolver.swift
//  Denavit–Hartenberg
//
//  Created by Freddie Nicholson on 17/01/2024.
//

import Foundation
import Accelerate

public struct iksolver {
    private static func deg2rad(_ number: Float) -> Float {
        return number * .pi / 180
    }
    private static func rad2deg(_ number: Float) -> Float {
        return number * 180 / .pi
    }
    private static func dtan(_ degree: Float) -> Float {
        return Float(tan(deg2rad(degree)))
    }
    
    private static func dcos(degree: Float) -> Float {
        return Float(cos(deg2rad(degree)))
    }
    
    private static func dsin(degree: Float) -> Float {
        return Float(sin(deg2rad(degree)))
    }
    
    
    private static func abcrotation(a: Float,b: Float,c: Float) -> [[Float]] {
        let C: [Float] = [
            [1, 0,0],
            [0,dcos(degree: c),-dsin(degree: c)],
            [0,dsin(degree: c),dcos(degree: c)],
        ].flatMap { $0 }
        
        let B: [Float] = [
            [dcos(degree: b), 0,dsin(degree: b)],
            [0,1,0],
            [-dsin(degree: b),0,dcos(degree: b)],
        ].flatMap { $0 }
        
        let A: [Float] = [
            [dcos(degree:a), -dsin(degree:a),0],
            [dsin(degree:a),dcos(degree:a),0],
            [0,0,1],
        ].flatMap { $0 }

        var finalmatrix: [Float] = [
            1.0, 0.0, 0.0,
            0.0, 1.0, 0.0,
            0.0, 0.0, 1.0,

        ]

        for matrix in [A,B,C] {
            var tmp: [Float] = [
                0.0, 0.0, 0.0,
                0.0, 0.0, 0.0,
                0.0, 0.0, 0.0,
                0.0, 0.0, 0.0,
            ]

            vDSP_mmul(
                finalmatrix, vDSP_Stride(1),
                matrix, vDSP_Stride(1),
                &tmp, vDSP_Stride(1),
                3, 3, 3
            )

            finalmatrix = tmp
        }
        
        let nicefinalmatrix = [
        [finalmatrix[0],finalmatrix[1],finalmatrix[2]],
        [finalmatrix[3],finalmatrix[4],finalmatrix[5]],
        [finalmatrix[6],finalmatrix[7],finalmatrix[8]],
    ]
        
        return nicefinalmatrix
    }
    
    public static func getTransformMatrix(desx: Float, desy:Float, desz:Float, roll: Float, pitch: Float, yaw: Float, rotate:Bool = true) -> [Float] {
        var desired_pos = [desx, desy,desz]
        var rotmatrix: [[Float]] = abcrotation(a:roll,b:pitch,c:yaw)
        var desired_t = [
            [rotmatrix[0][0], rotmatrix[0][1], rotmatrix[0][2], desired_pos[0]],
            [rotmatrix[1][0], rotmatrix[1][1], rotmatrix[1][2], desired_pos[1]],
            [rotmatrix[2][0], rotmatrix[2][1], rotmatrix[2][2], desired_pos[2]],
            [Float(0), Float(0), Float(0), Float(1)]
        ].flatMap { $0 }
        if(rotate) {
            var desired_t_rotated = fksolver.rotate_xaxis(theta: 90, matrix: desired_t)
            return desired_t_rotated
        } else {
            return desired_t
        }
    }
    
    public static func solveIK(desx: Float, desy:Float, desz:Float, d1: Float, d2: Float, d4: Float, d6: Float, a1: Float, a2: Float, roll: Float, pitch: Float, yaw: Float) -> [Float] {
        
        var desired_pos = [desx, desy,desz]
        
        
        var rotmatrix: [[Float]] = abcrotation(a:roll,b:pitch,c:yaw)

        
        var desired_t = [
            [rotmatrix[0][0], rotmatrix[0][1], rotmatrix[0][2], desired_pos[0]],
            [rotmatrix[1][0], rotmatrix[1][1], rotmatrix[1][2], desired_pos[1]],
            [rotmatrix[2][0], rotmatrix[2][1], rotmatrix[2][2], desired_pos[2]],
            [Float(0), Float(0), Float(0), Float(1)]
        ].flatMap { $0 }

        
        var desired_t_rotated = fksolver.rotate_xaxis(theta: 90, matrix: desired_t)
        

        desired_pos = [desired_t_rotated[3],desired_t_rotated[7],desired_t_rotated[11]]
        
        rotmatrix = [
            [desired_t_rotated[0],desired_t_rotated[1],desired_t_rotated[2]],
            [desired_t_rotated[4],desired_t_rotated[5],desired_t_rotated[6]],
            [desired_t_rotated[8],desired_t_rotated[9],desired_t_rotated[10]]
        ]
        
        var pwx = desired_pos[0] + rotmatrix[0][2]*d6

        var pwy = desired_pos[1] - rotmatrix[1][2]*d6
        var pwz = desired_pos[2] - rotmatrix[2][2]*d6


        
       
        //joint 1
        
        var q1 = atan2(pwy, pwx)
        let r = sqrt(pow(pwx,2)+pow(pwy,2))-a1
        
        //joint2
        let pwztilda = pwz-d1
        let s = sqrt(pow(r,2)+pow(pwztilda,2))
        let alpha = atan((pwztilda)/(r))
        let beta = acos((pow(s,2)+pow(a2,2)-pow(d4,2))/(2*a2*s))
        let q2 = .pi/2 - alpha - beta
        
        //joint3
        let gamma = acos((pow(a2,2)+pow(d4,2)-pow(s,2))/(2*a2*d4))
        let q3 = .pi/2 - gamma
        
        
        var R03DofRobotDH: [fksolver.dh_row] = []
        R03DofRobotDH.append(fksolver.dh_row(q: q1, d: d1, a: a1, alpha: 90))
        R03DofRobotDH.append(fksolver.dh_row(q: q2+90, d: d2, a: a2, alpha: 0))
        R03DofRobotDH.append(fksolver.dh_row(q: q3, d: 0, a: 0, alpha: 90))


        
         
        
        var R03 = fksolver.get_r(dh: R03DofRobotDH, to: 2)
        
        R03 = [R03[0], R03[1], R03[2], R03[4], R03[5], R03[6], R03[8], R03[9], R03[10]]

        var R36: [Float] = [
            1.0, 0.0, 0.0,
            0.0, 1.0, 0.0,
            0.0, 0.0, 1.0,

        ]
        
        var R03T: [Float] = [
            1.0, 0.0, 0.0,
            0.0, 1.0, 0.0,
            0.0, 0.0, 1.0,
        ]
        
        vDSP_mtrans(
            R03, 
            vDSP_Stride(1),
            &R03T,
            vDSP_Stride(1),
            3, 3
        )
        
        vDSP_mmul(
            R03T, vDSP_Stride(1),
            rotmatrix.flatMap { $0 }, vDSP_Stride(1),
            &R36, vDSP_Stride(1),
            3, 3, 3
        )
        let R36nice: [[Float]] = [
            [R36[0], R36[1], R36[2]],
            [R36[3], R36[4], R36[5]],
            [R36[6], R36[7], R36[8]],
        ]

        
        let q4 = atan2(R36[5],R36[2])
        let q5 = acos(-R36[8])
        let q6 = atan2(-(R36[7]),R36[6])
        
        


        return [rad2deg(q1),-rad2deg(q2),-rad2deg(q3),rad2deg(q4),rad2deg(q5),rad2deg(q6)]
        
    }
    
    public static func solveIK2(transformMatrix: [Float], d1: Float, d2: Float, d4: Float, d6: Float, a1: Float, a2: Float) -> [Float] {
        
        
        var desired_t_rotated = transformMatrix
        

        var desired_pos = [desired_t_rotated[3],desired_t_rotated[7],desired_t_rotated[11]]
        
        var rotmatrix = [
            [desired_t_rotated[0],desired_t_rotated[1],desired_t_rotated[2]],
            [desired_t_rotated[4],desired_t_rotated[5],desired_t_rotated[6]],
            [desired_t_rotated[8],desired_t_rotated[9],desired_t_rotated[10]]
        ]
        
        var pwx = desired_pos[0] + rotmatrix[0][2]*d6

        var pwy = desired_pos[1] - rotmatrix[1][2]*d6
        var pwz = desired_pos[2] - rotmatrix[2][2]*d6

        

        
       
        //joint 1
        
        var q1 = atan2(pwy, pwx)
        let r = sqrt(pow(pwx,2)+pow(pwy,2))-a1
        
        //joint2
        let pwztilda = pwz-d1
        let s = sqrt(pow(r,2)+pow(pwztilda,2))
        let alpha = atan((pwztilda)/(r))
        let beta = acos((pow(s,2)+pow(a2,2)-pow(d4,2))/(2*a2*s))
        let q2 = .pi/2 - alpha - beta
        
        //joint3
        let gamma = acos((pow(a2,2)+pow(d4,2)-pow(s,2))/(2*a2*d4))
        let q3 = .pi/2 - gamma
        
        
        var R03DofRobotDH: [fksolver.dh_row] = []
        R03DofRobotDH.append(fksolver.dh_row(q: q1, d: d1, a: a1, alpha: 90))
        R03DofRobotDH.append(fksolver.dh_row(q: q2+90, d: d2, a: a2, alpha: 0))
        R03DofRobotDH.append(fksolver.dh_row(q: q3, d: 0, a: 0, alpha: 90))

        
        var R03 = fksolver.get_r(dh: R03DofRobotDH, to: 2)
        
        R03 = [R03[0], R03[1], R03[2], R03[4], R03[5], R03[6], R03[8], R03[9], R03[10]]

        var R36: [Float] = [
            1.0, 0.0, 0.0,
            0.0, 1.0, 0.0,
            0.0, 0.0, 1.0,

        ]
        
        var R03T: [Float] = [
            1.0, 0.0, 0.0,
            0.0, 1.0, 0.0,
            0.0, 0.0, 1.0,
        ]
        
        vDSP_mtrans(
            R03,
            vDSP_Stride(1),
            &R03T,
            vDSP_Stride(1),
            3, 3
        )
        
        
        vDSP_mmul(
            R03T, vDSP_Stride(1),
            rotmatrix.flatMap { $0 }, vDSP_Stride(1),
            &R36, vDSP_Stride(1),
            3, 3, 3
        )
     
        let R36nice: [[Float]] = [
            [R36[0], R36[1], R36[2]],
            [R36[3], R36[4], R36[5]],
            [R36[6], R36[7], R36[8]],
        ]

        let q4 = atan2(R36[5],R36[2])
        let q5 = acos(-R36[8])
        let q6 = atan2(-(R36[7]),R36[6])
        
        


        return [rad2deg(q1),-rad2deg(q2),-rad2deg(q3),rad2deg(q4),rad2deg(q5),rad2deg(q6)]
        
    }
    
    public static func solveIKDiffSolutions(desx: Float, desy:Float, desz:Float, d1: Float, d2: Float, d4: Float, d6: Float, a1: Float, a2: Float, roll: Float, pitch: Float, yaw: Float, shoulder: Bool, elbow: Bool,wrist: Bool) -> [Float] {
        
        var desired_pos = [desx, desy,desz]
                
        var rotmatrix: [[Float]] = abcrotation(a:roll,b:pitch,c:yaw)
        
        var desired_t = [
            [rotmatrix[0][0], rotmatrix[0][1], rotmatrix[0][2], desired_pos[0]],
            [rotmatrix[1][0], rotmatrix[1][1], rotmatrix[1][2], desired_pos[1]],
            [rotmatrix[2][0], rotmatrix[2][1], rotmatrix[2][2], desired_pos[2]],
            [Float(0), Float(0), Float(0), Float(1)]
        ].flatMap { $0 }

        
        var desired_t_rotated = fksolver.rotate_xaxis(theta: 90, matrix: desired_t)
        

        desired_pos = [desired_t_rotated[3],desired_t_rotated[7],desired_t_rotated[11]]
        
        rotmatrix = [
            [desired_t_rotated[0],desired_t_rotated[1],desired_t_rotated[2]],
            [desired_t_rotated[4],desired_t_rotated[5],desired_t_rotated[6]],
            [desired_t_rotated[8],desired_t_rotated[9],desired_t_rotated[10]]
        ]
        
        var pwx = desired_pos[0] + rotmatrix[0][2]*d6

        var pwy = desired_pos[1] - rotmatrix[1][2]*d6
        var pwz = desired_pos[2] - rotmatrix[2][2]*d6
        
   

        
       
        //joint 1
        
        var q1 = atan2(pwy, pwx)
        var r = sqrt(pow(pwx,2)+pow(pwy,2))-a1

        if(!shoulder) {
            q1 = atan2(pwy, pwx) + .pi
            r+=a1+0.08
        }
        
        //joint2
        let pwztilda = pwz-d1
        let s = sqrt(pow(r,2)+pow(pwztilda,2))
        let alpha = atan((pwztilda)/(r))
        var beta = acos((pow(s,2)+pow(a2,2)-pow(d4,2))/(2*a2*s))
        if(!elbow) {
            beta = -beta
        }

        var q2 = .pi/2 - alpha - beta
        
        if(!shoulder) {
            q2 = -q2
        }
        
        //joint3
        var gamma = acos((pow(a2,2)+pow(d4,2)-pow(s,2))/(2*a2*d4))
        if(!elbow) {
            gamma = -gamma
        }
        var q3 = .pi/2 - gamma
        if(!shoulder) {
            q3 = .pi-q3
        }
        

        
        
        var R03DofRobotDH: [fksolver.dh_row] = []
        R03DofRobotDH.append(fksolver.dh_row(q: q1, d: d1, a: a1, alpha: 90))
        R03DofRobotDH.append(fksolver.dh_row(q: q2+90, d: d2, a: a2, alpha: 0))
        R03DofRobotDH.append(fksolver.dh_row(q: q3, d: 0, a: 0, alpha: 90))

        
         
        
        var R03 = fksolver.get_r(dh: R03DofRobotDH, to: 2)
        
        
        R03 = [R03[0], R03[1], R03[2], R03[4], R03[5], R03[6], R03[8], R03[9], R03[10]]

        var R36: [Float] = [
            1.0, 0.0, 0.0,
            0.0, 1.0, 0.0,
            0.0, 0.0, 1.0,

        ]
        
        var R03T: [Float] = [
            1.0, 0.0, 0.0,
            0.0, 1.0, 0.0,
            0.0, 0.0, 1.0,
        ]
        
        vDSP_mtrans(
            R03,
            vDSP_Stride(1),
            &R03T,
            vDSP_Stride(1),
            3, 3
        )
      
        
        vDSP_mmul(
            R03T, vDSP_Stride(1),
            rotmatrix.flatMap { $0 }, vDSP_Stride(1),
            &R36, vDSP_Stride(1),
            3, 3, 3
        )
    
        let R36nice: [[Float]] = [
            [R36[0], R36[1], R36[2]],
            [R36[3], R36[4], R36[5]],
            [R36[6], R36[7], R36[8]],
        ]

        var q4 = atan2(R36[5],R36[2])
        var q5 = acos(-R36[8])
        var q6 = atan2(-(R36[7]),R36[6])
        if(!wrist) {
            q5 = -q5
        }
        
        if(!wrist) {
            q4 = q4 - .pi
        }
        if(!shoulder) {
            q4 = q4 - .pi
        }
        if(!wrist) {
            q6 = q6 - 2 * .pi
        }

        return [rad2deg(q1),-rad2deg(q2),-rad2deg(q3),rad2deg(q4),rad2deg(q5),rad2deg(q6)]
        
    }
}

