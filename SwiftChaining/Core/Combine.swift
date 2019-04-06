//
//  Combine.swift
//

import Foundation

extension Chain where ChainType: FetchableProtocol {
    public func combine<Out1, ChainType1>(_ chain1: Chain<Out1, ChainType1>) -> Chain<(Out, Out1), ChainType> where ChainType1: FetchableProtocol {
        return self.combine0(chain1)
    }
    
    public func combine<Out1, ChainType1, T0, T1>(_ chain1: Chain<Out1, ChainType1>) -> Chain<(T0, T1, Out1), ChainType> where Out == (T0, T1), ChainType1: FetchableProtocol {
        return self.combine0(chain1).map { ($0.0, $0.1, $1) }
    }
    
    public func combine<Out1, ChainType1, T0, T1, T2>(_ chain1: Chain<Out1, ChainType1>) -> Chain<(T0, T1, T2, Out1), ChainType> where Out == (T0, T1, T2), ChainType1: FetchableProtocol {
        return self.combine0(chain1).map { ($0.0, $0.1, $0.2, $1) }
    }
    
    public func combine<Out1, ChainType1, T0, T1, T2, T3>(_ chain1: Chain<Out1, ChainType1>) -> Chain<(T0, T1, T2, T3, Out1), ChainType> where Out == (T0, T1, T2, T3), ChainType1: FetchableProtocol {
        return self.combine0(chain1).map { ($0.0, $0.1, $0.2, $0.3, $1) }
    }
    
    public func combine<Out1, ChainType1>(_ chain1: Chain<Out1, ChainType1>) -> Chain<(Out, Out1), ChainType> {
        return self.combine0(chain1)
    }
    
    public func combine<Out1, ChainType1, T0, T1>(_ chain1: Chain<Out1, ChainType1>) -> Chain<(T0, T1, Out1), ChainType> where Out == (T0, T1) {
        return self.combine0(chain1).map { ($0.0, $0.1, $1) }
    }
    
    public func combine<Out1, ChainType1, T0, T1, T2>(_ chain1: Chain<Out1, ChainType1>) -> Chain<(T0, T1, T2, Out1), ChainType> where Out == (T0, T1, T2) {
        return self.combine0(chain1).map { ($0.0, $0.1, $0.2, $1) }
    }
    
    public func combine<Out1, ChainType1, T0, T1, T2, T3>(_ chain1: Chain<Out1, ChainType1>) -> Chain<(T0, T1, T2, T3, Out1), ChainType> where Out == (T0, T1, T2, T3) {
        return self.combine0(chain1).map { ($0.0, $0.1, $0.2, $0.3, $1) }
    }
}

extension Chain {
    public func combine<Out1, ChainType1>(_ chain1: Chain<Out1, ChainType1>) -> Chain<(Out, Out1), ChainType1> where ChainType1: FetchableProtocol {
        return self.combine1(chain1)
    }
    
    public func combine<Out1, ChainType1, T0, T1>(_ chain1: Chain<Out1, ChainType1>) -> Chain<(T0, T1, Out1), ChainType1> where Out == (T0, T1), ChainType1: FetchableProtocol {
        return self.combine1(chain1).map { ($0.0, $0.1, $1) }
    }
    
    public func combine<Out1, ChainType1, T0, T1, T2>(_ chain1: Chain<Out1, ChainType1>) -> Chain<(T0, T1, T2, Out1), ChainType1> where Out == (T0, T1, T2), ChainType1: FetchableProtocol {
        return self.combine1(chain1).map { ($0.0, $0.1, $0.2, $1) }
    }
    
    public func combine<Out1, ChainType1, T0, T1, T2, T3>(_ chain1: Chain<Out1, ChainType1>) -> Chain<(T0, T1, T2, T3, Out1), ChainType1> where Out == (T0, T1, T2, T3), ChainType1: FetchableProtocol {
        return self.combine1(chain1).map { ($0.0, $0.1, $0.2, $0.3, $1) }
    }
    
    public func combine<Out1, ChainType1>(_ chain1: Chain<Out1, ChainType1>) -> Chain<(Out, Out1), ChainType> {
        return self.combine0(chain1)
    }
    
    public func combine<Out1, ChainType1, T0, T1>(_ chain1: Chain<Out1, ChainType1>) -> Chain<(T0, T1, Out1), ChainType> where Out == (T0, T1) {
        return self.combine0(chain1).map { ($0.0, $0.1, $1) }
    }
    
    public func combine<Out1, ChainType1, T0, T1, T2>(_ chain1: Chain<Out1, ChainType1>) -> Chain<(T0, T1, T2, Out1), ChainType> where Out == (T0, T1, T2) {
        return self.combine0(chain1).map { ($0.0, $0.1, $0.2, $1) }
    }
    
    public func combine<Out1, ChainType1, T0, T1, T2, T3>(_ chain1: Chain<Out1, ChainType1>) -> Chain<(T0, T1, T2, T3, Out1), ChainType> where Out == (T0, T1, T2, T3) {
        return self.combine0(chain1).map { ($0.0, $0.1, $0.2, $0.3, $1) }
    }
}

extension Chain {
    private func combine0<Out1, ChainType1>(_ chain1: Chain<Out1, ChainType1>) -> Chain<(Out, Out1), ChainType> {
        return self.tuple(chain1).cache().complete()
    }
    
    private func combine1<Out1, ChainType1>(_ chain1: Chain<Out1, ChainType1>) -> Chain<(Out, Out1), ChainType1> where ChainType1: FetchableProtocol {
        return self.tuple(chain1).cache().complete()
    }
    
    private func cache<T0, T1>() -> Chain<Out, ChainType> where Out == (T0?, T1?) {
        var cache: (T0?, T1?) = (nil, nil)
        return self.map {
            if let in0 = $0.0 { cache.0 = in0 }
            if let in1 = $0.1 { cache.1 = in1 }
            return cache
        }
    }
    
    private func complete<T0, T1>() -> Chain<(T0, T1), ChainType> where Out == (T0?, T1?) {
        return self.guard { $0.0 != nil && $0.1 != nil }.map { ($0.0!, $0.1!) }
    }
}
