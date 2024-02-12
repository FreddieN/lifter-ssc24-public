//
//  fksolver.swift
//  Denavit–Hartenberg
//
//  Created by Freddie Nicholson on 16/01/2024.
//

import Foundation
import Accelerate

public struct fksolver {
    private static func deg2rad(_ number: Float) -> Float {
        return number * .pi / 180
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
    
    private static func transformation_matrix(q: Float,d: Float,a: Float,alpha: Float) -> [Float] {
        let T: [Float] = [
            [dcos(degree: q), -dcos(degree: alpha)*dsin(degree: q), dsin(degree: alpha)*dsin(degree: q), a*dcos(degree: q)],
            [dsin(degree: q), dcos(degree: alpha)*dcos(degree: q), -dcos(degree: q)*dsin(degree: alpha), a*dsin(degree: q)],
            [0, dsin(degree: alpha), dcos(degree: alpha) ,d],
            [0,0,0,1]
        ].flatMap { $0 }
        return T
    }
    
    public static func rotate_xaxis(theta: Float,matrix: [Float]) -> [Float] {
        let T: [Float] = [
            [1, 0,0, 0],
            [0,dcos(degree: theta),-dsin(degree: theta),0],
            [0,dsin(degree: theta),dcos(degree: theta),0],
           [0,0,0,1]
        ].flatMap { $0 }
        
        var out: [Float] = [
            1.0, 0.0, 0.0, 0.0,
            0.0, 1.0, 0.0, 0.0,
            0.0, 0.0, 1.0, 0.0,
            0.0, 0.0, 0.0, 1.0
        ]

        vDSP_mmul(
            T, vDSP_Stride(1),
            matrix, vDSP_Stride(1),
            &out, vDSP_Stride(1),
            4, 4, 4
        )

        return out
    }
    
    
    public static func solveFK(q1: Float, q2:Float, q3:Float, q4:Float, q5:Float, q6:Float, d1: Float, d2: Float, d4: Float, d6: Float, a1: Float, a2: Float) -> SIMD3<Float> {
        let T0 = transformation_matrix(q: q1, d: d1, a: a1, alpha: 90)
        let T1 = transformation_matrix(q: q2+90, d: d2, a: a2, alpha: 0)
        let T2 = transformation_matrix(q: q3, d: 0, a: 0, alpha: 90)
        let T3 = transformation_matrix(q: q4, d: d4, a: 0, alpha: -90)
        let T4 = transformation_matrix(q: q5, d: 0, a: 0, alpha: 90)
        let T5 = transformation_matrix(q: q6, d: d6, a: 0, alpha: 0)
        
       
        
            var T6: [Float] = [
                1.0, 0.0, 0.0, 0.0,
                0.0, 1.0, 0.0, 0.0,
                0.0, 0.0, 1.0, 0.0,
                0.0, 0.0, 0.0, 1.0
            ]

            for matrix in [T0, T1,T2,T3,T4,T5] {
                var tmp: [Float] = [
                    0.0, 0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0, 0.0
                ]

                vDSP_mmul(
                    T6, vDSP_Stride(1),
                    matrix, vDSP_Stride(1),
                    &tmp, vDSP_Stride(1),
                    4, 4, 4
                )

                T6 = tmp
            }
        
       
        return SIMD3(T6[3],T6[11],-T6[7])
        
    }
    
    public struct dh_row {
        var q: Float
        var d: Float
        var a: Float
        var alpha: Float
    }
    
    public static func get_r(dh: [dh_row], to:Int = -1) -> [Float] {
        if(to == -1) {
            let goTo = dh.count
        } else {
            let goTo = to
        }
        var matrices: [[Float]] = []
        for (index, row) in dh.enumerated() {
            matrices.append(transformation_matrix(q: row.q, d: row.d, a: row.a, alpha: row.alpha))
            if(index == to) {
                break
            }
        }

        
            var finalmatrix: [Float] = [
                1.0, 0.0, 0.0, 0.0,
                0.0, 1.0, 0.0, 0.0,
                0.0, 0.0, 1.0, 0.0,
                0.0, 0.0, 0.0, 1.0
            ]

            for matrix in matrices {
                var tmp: [Float] = [
                    0.0, 0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0, 0.0
                ]

                vDSP_mmul(
                    finalmatrix, vDSP_Stride(1),
                    matrix, vDSP_Stride(1),
                    &tmp, vDSP_Stride(1),
                    4, 4, 4
                )

                finalmatrix = tmp
            }
        return finalmatrix
    }
    
    public static func solveFK2(dh: [dh_row], to:Int = -1) -> SIMD3<Float> {
        var finalmatrix = get_r(dh: dh, to: to)
        
    
        finalmatrix = rotate_xaxis(theta: -90, matrix:finalmatrix)
        return SIMD3(finalmatrix[3],finalmatrix[7],finalmatrix[11])
        
    }
    
    
    public static func solveFK3(dh: [dh_row], to:Int = -1) -> [Float] {
        var finalmatrix = get_r(dh: dh, to: to)
        
        
        finalmatrix = rotate_xaxis(theta: -90, matrix:finalmatrix)
        return finalmatrix
        
    }
}

