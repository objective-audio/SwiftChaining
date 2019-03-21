//
//  Combine.swift
//

import Foundation

extension Chain where Chainer: Fetchable {
    public func combine<Out1, Sender1>(_ chain1: Chain<Out1, Sender1>) -> Chain<(Out, Out1), Chainer> where Sender1: Fetchable {
        return self.combine0(chain1)
    }
    
    public func combine<Out1, Sender1, T0, T1>(_ chain1: Chain<Out1, Sender1>) -> Chain<(T0, T1, Out1), Chainer> where Out == (T0, T1), Sender1: Fetchable {
        return self.combine0(chain1).map { ($0.0, $0.1, $1) }
    }
    
    public func combine<Out1, Sender1, T0, T1, T2>(_ chain1: Chain<Out1, Sender1>) -> Chain<(T0, T1, T2, Out1), Chainer> where Out == (T0, T1, T2), Sender1: Fetchable {
        return self.combine0(chain1).map { ($0.0, $0.1, $0.2, $1) }
    }
    
    public func combine<Out1, Sender1, T0, T1, T2, T3>(_ chain1: Chain<Out1, Sender1>) -> Chain<(T0, T1, T2, T3, Out1), Chainer> where Out == (T0, T1, T2, T3), Sender1: Fetchable {
        return self.combine0(chain1).map { ($0.0, $0.1, $0.2, $0.3, $1) }
    }
    
    public func combine<Out1, Sender1>(_ chain1: Chain<Out1, Sender1>) -> Chain<(Out, Out1), Chainer> {
        return self.combine0(chain1)
    }
    
    public func combine<Out1, Sender1, T0, T1>(_ chain1: Chain<Out1, Sender1>) -> Chain<(T0, T1, Out1), Chainer> where Out == (T0, T1) {
        return self.combine0(chain1).map { ($0.0, $0.1, $1) }
    }
    
    public func combine<Out1, Sender1, T0, T1, T2>(_ chain1: Chain<Out1, Sender1>) -> Chain<(T0, T1, T2, Out1), Chainer> where Out == (T0, T1, T2) {
        return self.combine0(chain1).map { ($0.0, $0.1, $0.2, $1) }
    }
    
    public func combine<Out1, Sender1, T0, T1, T2, T3>(_ chain1: Chain<Out1, Sender1>) -> Chain<(T0, T1, T2, T3, Out1), Chainer> where Out == (T0, T1, T2, T3) {
        return self.combine0(chain1).map { ($0.0, $0.1, $0.2, $0.3, $1) }
    }
}

extension Chain {
    public func combine<Out1, Sender1>(_ chain1: Chain<Out1, Sender1>) -> Chain<(Out, Out1), Sender1> where Sender1: Fetchable {
        return self.combine1(chain1)
    }
    
    public func combine<Out1, Sender1, T0, T1>(_ chain1: Chain<Out1, Sender1>) -> Chain<(T0, T1, Out1), Sender1> where Out == (T0, T1), Sender1: Fetchable {
        return self.combine1(chain1).map { ($0.0, $0.1, $1) }
    }
    
    public func combine<Out1, Sender1, T0, T1, T2>(_ chain1: Chain<Out1, Sender1>) -> Chain<(T0, T1, T2, Out1), Sender1> where Out == (T0, T1, T2), Sender1: Fetchable {
        return self.combine1(chain1).map { ($0.0, $0.1, $0.2, $1) }
    }
    
    public func combine<Out1, Sender1, T0, T1, T2, T3>(_ chain1: Chain<Out1, Sender1>) -> Chain<(T0, T1, T2, T3, Out1), Sender1> where Out == (T0, T1, T2, T3), Sender1: Fetchable {
        return self.combine1(chain1).map { ($0.0, $0.1, $0.2, $0.3, $1) }
    }
    
    public func combine<Out1, Sender1>(_ chain1: Chain<Out1, Sender1>) -> Chain<(Out, Out1), Chainer> {
        return self.combine0(chain1)
    }
    
    public func combine<Out1, Sender1, T0, T1>(_ chain1: Chain<Out1, Sender1>) -> Chain<(T0, T1, Out1), Chainer> where Out == (T0, T1) {
        return self.combine0(chain1).map { ($0.0, $0.1, $1) }
    }
    
    public func combine<Out1, Sender1, T0, T1, T2>(_ chain1: Chain<Out1, Sender1>) -> Chain<(T0, T1, T2, Out1), Chainer> where Out == (T0, T1, T2) {
        return self.combine0(chain1).map { ($0.0, $0.1, $0.2, $1) }
    }
    
    public func combine<Out1, Sender1, T0, T1, T2, T3>(_ chain1: Chain<Out1, Sender1>) -> Chain<(T0, T1, T2, T3, Out1), Chainer> where Out == (T0, T1, T2, T3) {
        return self.combine0(chain1).map { ($0.0, $0.1, $0.2, $0.3, $1) }
    }
}

extension Chain {
    private func combine0<Out1, Sender1>(_ chain1: Chain<Out1, Sender1>) -> Chain<(Out, Out1), Chainer> {
        return self.tuple(chain1).cache().complete()
    }
    
    private func combine1<Out1, Sender1>(_ chain1: Chain<Out1, Sender1>) -> Chain<(Out, Out1), Sender1> where Sender1: Fetchable {
        return self.tuple(chain1).cache().complete()
    }
    
    private func cache<T0, T1>() -> Chain<Out, Chainer> where Out == (T0?, T1?) {
        var cache: (T0?, T1?) = (nil, nil)
        return self.map {
            if let in0 = $0.0 { cache.0 = in0 }
            if let in1 = $0.1 { cache.1 = in1 }
            return cache
        }
    }
    
    private func complete<T0, T1>() -> Chain<(T0, T1), Chainer> where Out == (T0?, T1?) {
        return self.guard { $0.0 != nil && $0.1 != nil }.map { ($0.0!, $0.1!) }
    }
}
