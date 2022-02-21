; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

; If we have some pattern that leaves only some low bits set, and then performs
; left-shift of those bits, if none of the bits that are left after the final
; shift are modified by the mask, we can omit the mask.

; There are many variants to this pattern:
;   d)  (x & ((-1 << maskNbits) >> maskNbits)) << shiftNbits
; simplify to:
;   x << shiftNbits
; iff (shiftNbits-maskNbits) s>= 0 (i.e. shiftNbits u>= maskNbits)

; Simple tests. We don't care about extra uses.

declare void @use32(i32)

define i32 @t0_basic(i32 %x, i32 %nbits) {
; CHECK-LABEL: @t0_basic(
; CHECK-NEXT:    [[T0:%.*]] = shl i32 -1, [[NBITS:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = lshr i32 [[T0]], [[NBITS]]
; CHECK-NEXT:    [[T2:%.*]] = and i32 [[T1]], [[X:%.*]]
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    [[T4:%.*]] = shl i32 [[X]], [[NBITS]]
; CHECK-NEXT:    ret i32 [[T4]]
;
  %t0 = shl i32 -1, %nbits
  %t1 = lshr i32 %t0, %nbits
  %t2 = and i32 %t1, %x
  call void @use32(i32 %t0)
  call void @use32(i32 %t1)
  call void @use32(i32 %t2)
  %t4 = shl i32 %t2, %nbits
  ret i32 %t4
}

define i32 @t1_bigger_shift(i32 %x, i32 %nbits) {
; CHECK-LABEL: @t1_bigger_shift(
; CHECK-NEXT:    [[T0:%.*]] = shl i32 -1, [[NBITS:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = lshr i32 [[T0]], [[NBITS]]
; CHECK-NEXT:    [[T2:%.*]] = and i32 [[T1]], [[X:%.*]]
; CHECK-NEXT:    [[T3:%.*]] = add i32 [[NBITS]], 1
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    call void @use32(i32 [[T3]])
; CHECK-NEXT:    [[T4:%.*]] = shl i32 [[X]], [[T3]]
; CHECK-NEXT:    ret i32 [[T4]]
;
  %t0 = shl i32 -1, %nbits
  %t1 = lshr i32 %t0, %nbits
  %t2 = and i32 %t1, %x
  %t3 = add i32 %nbits, 1
  call void @use32(i32 %t0)
  call void @use32(i32 %t1)
  call void @use32(i32 %t2)
  call void @use32(i32 %t3)
  %t4 = shl i32 %t2, %t3
  ret i32 %t4
}

; Vectors

declare void @use3xi32(<3 x i32>)

define <3 x i32> @t2_vec_splat(<3 x i32> %x, <3 x i32> %nbits) {
; CHECK-LABEL: @t2_vec_splat(
; CHECK-NEXT:    [[T0:%.*]] = shl <3 x i32> <i32 -1, i32 -1, i32 -1>, [[NBITS:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = lshr <3 x i32> [[T0]], [[NBITS]]
; CHECK-NEXT:    [[T2:%.*]] = and <3 x i32> [[T1]], [[X:%.*]]
; CHECK-NEXT:    [[T3:%.*]] = add <3 x i32> [[NBITS]], <i32 1, i32 1, i32 1>
; CHECK-NEXT:    call void @use3xi32(<3 x i32> [[T0]])
; CHECK-NEXT:    call void @use3xi32(<3 x i32> [[T1]])
; CHECK-NEXT:    call void @use3xi32(<3 x i32> [[T2]])
; CHECK-NEXT:    call void @use3xi32(<3 x i32> [[T3]])
; CHECK-NEXT:    [[T4:%.*]] = shl <3 x i32> [[X]], [[T3]]
; CHECK-NEXT:    ret <3 x i32> [[T4]]
;
  %t0 = shl <3 x i32> <i32 -1, i32 -1, i32 -1>, %nbits
  %t1 = lshr <3 x i32> %t0, %nbits
  %t2 = and <3 x i32> %t1, %x
  %t3 = add <3 x i32> %nbits, <i32 1, i32 1, i32 1>
  call void @use3xi32(<3 x i32> %t0)
  call void @use3xi32(<3 x i32> %t1)
  call void @use3xi32(<3 x i32> %t2)
  call void @use3xi32(<3 x i32> %t3)
  %t4 = shl <3 x i32> %t2, %t3
  ret <3 x i32> %t4
}

define <3 x i32> @t3_vec_nonsplat(<3 x i32> %x, <3 x i32> %nbits) {
; CHECK-LABEL: @t3_vec_nonsplat(
; CHECK-NEXT:    [[T0:%.*]] = shl <3 x i32> <i32 -1, i32 -1, i32 -1>, [[NBITS:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = lshr <3 x i32> [[T0]], [[NBITS]]
; CHECK-NEXT:    [[T2:%.*]] = and <3 x i32> [[T1]], [[X:%.*]]
; CHECK-NEXT:    [[T3:%.*]] = add <3 x i32> [[NBITS]], <i32 1, i32 0, i32 2>
; CHECK-NEXT:    call void @use3xi32(<3 x i32> [[T0]])
; CHECK-NEXT:    call void @use3xi32(<3 x i32> [[T1]])
; CHECK-NEXT:    call void @use3xi32(<3 x i32> [[T2]])
; CHECK-NEXT:    call void @use3xi32(<3 x i32> [[T3]])
; CHECK-NEXT:    [[T4:%.*]] = shl <3 x i32> [[X]], [[T3]]
; CHECK-NEXT:    ret <3 x i32> [[T4]]
;
  %t0 = shl <3 x i32> <i32 -1, i32 -1, i32 -1>, %nbits
  %t1 = lshr <3 x i32> %t0, %nbits
  %t2 = and <3 x i32> %t1, %x
  %t3 = add <3 x i32> %nbits, <i32 1, i32 0, i32 2>
  call void @use3xi32(<3 x i32> %t0)
  call void @use3xi32(<3 x i32> %t1)
  call void @use3xi32(<3 x i32> %t2)
  call void @use3xi32(<3 x i32> %t3)
  %t4 = shl <3 x i32> %t2, %t3
  ret <3 x i32> %t4
}

define <3 x i32> @t4_vec_undef(<3 x i32> %x, <3 x i32> %nbits) {
; CHECK-LABEL: @t4_vec_undef(
; CHECK-NEXT:    [[T0:%.*]] = shl <3 x i32> <i32 -1, i32 undef, i32 -1>, [[NBITS:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = lshr <3 x i32> [[T0]], [[NBITS]]
; CHECK-NEXT:    [[T2:%.*]] = and <3 x i32> [[T1]], [[X:%.*]]
; CHECK-NEXT:    call void @use3xi32(<3 x i32> [[T0]])
; CHECK-NEXT:    call void @use3xi32(<3 x i32> [[T1]])
; CHECK-NEXT:    call void @use3xi32(<3 x i32> [[T2]])
; CHECK-NEXT:    call void @use3xi32(<3 x i32> [[NBITS]])
; CHECK-NEXT:    [[T4:%.*]] = shl <3 x i32> [[X]], [[NBITS]]
; CHECK-NEXT:    ret <3 x i32> [[T4]]
;
  %t0 = shl <3 x i32> <i32 -1, i32 undef, i32 -1>, %nbits
  %t1 = lshr <3 x i32> %t0, %nbits
  %t2 = and <3 x i32> %t1, %x
  %t3 = add <3 x i32> %nbits, <i32 0, i32 undef, i32 0>
  call void @use3xi32(<3 x i32> %t0)
  call void @use3xi32(<3 x i32> %t1)
  call void @use3xi32(<3 x i32> %t2)
  call void @use3xi32(<3 x i32> %t3)
  %t4 = shl <3 x i32> %t2, %t3
  ret <3 x i32> %t4
}

; Commutativity

declare i32 @gen32()

define i32 @t5_commutativity0(i32 %nbits) {
; CHECK-LABEL: @t5_commutativity0(
; CHECK-NEXT:    [[X:%.*]] = call i32 @gen32()
; CHECK-NEXT:    [[T0:%.*]] = shl i32 -1, [[NBITS:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = lshr i32 [[T0]], [[NBITS]]
; CHECK-NEXT:    [[T2:%.*]] = and i32 [[X]], [[T1]]
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    [[T3:%.*]] = shl i32 [[X]], [[NBITS]]
; CHECK-NEXT:    ret i32 [[T3]]
;
  %x = call i32 @gen32()
  %t0 = shl i32 -1, %nbits
  %t1 = lshr i32 %t0, %nbits
  %t2 = and i32 %x, %t1 ; swapped order
  call void @use32(i32 %t0)
  call void @use32(i32 %t1)
  call void @use32(i32 %t2)
  %t3 = shl i32 %t2, %nbits
  ret i32 %t3
}

define i32 @t6_commutativity1(i32 %nbits0, i32 %nbits1) {
; CHECK-LABEL: @t6_commutativity1(
; CHECK-NEXT:    [[T0:%.*]] = shl i32 -1, [[NBITS0:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = lshr i32 [[T0]], [[NBITS0]]
; CHECK-NEXT:    [[T2:%.*]] = shl i32 -1, [[NBITS1:%.*]]
; CHECK-NEXT:    [[T3:%.*]] = lshr i32 [[T0]], [[NBITS1]]
; CHECK-NEXT:    [[T4:%.*]] = and i32 [[T3]], [[T1]]
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    call void @use32(i32 [[T3]])
; CHECK-NEXT:    call void @use32(i32 [[T4]])
; CHECK-NEXT:    [[T5:%.*]] = shl i32 [[T3]], [[NBITS0]]
; CHECK-NEXT:    ret i32 [[T5]]
;
  %t0 = shl i32 -1, %nbits0
  %t1 = lshr i32 %t0, %nbits0
  %t2 = shl i32 -1, %nbits1
  %t3 = lshr i32 %t0, %nbits1
  %t4 = and i32 %t3, %t1 ; both hands of 'and' could be mask..
  call void @use32(i32 %t0)
  call void @use32(i32 %t1)
  call void @use32(i32 %t2)
  call void @use32(i32 %t3)
  call void @use32(i32 %t4)
  %t5 = shl i32 %t4, %nbits0
  ret i32 %t5
}
define i32 @t7_commutativity2(i32 %nbits0, i32 %nbits1) {
; CHECK-LABEL: @t7_commutativity2(
; CHECK-NEXT:    [[T0:%.*]] = shl i32 -1, [[NBITS0:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = lshr i32 [[T0]], [[NBITS0]]
; CHECK-NEXT:    [[T2:%.*]] = shl i32 -1, [[NBITS1:%.*]]
; CHECK-NEXT:    [[T3:%.*]] = lshr i32 [[T0]], [[NBITS1]]
; CHECK-NEXT:    [[T4:%.*]] = and i32 [[T3]], [[T1]]
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    call void @use32(i32 [[T3]])
; CHECK-NEXT:    call void @use32(i32 [[T4]])
; CHECK-NEXT:    [[T5:%.*]] = shl i32 [[T4]], [[NBITS1]]
; CHECK-NEXT:    ret i32 [[T5]]
;
  %t0 = shl i32 -1, %nbits0
  %t1 = lshr i32 %t0, %nbits0
  %t2 = shl i32 -1, %nbits1
  %t3 = lshr i32 %t0, %nbits1
  %t4 = and i32 %t3, %t1 ; both hands of 'and' could be mask..
  call void @use32(i32 %t0)
  call void @use32(i32 %t1)
  call void @use32(i32 %t2)
  call void @use32(i32 %t3)
  call void @use32(i32 %t4)
  %t5 = shl i32 %t4, %nbits1
  ret i32 %t5
}

; Fast-math flags. We must not preserve them!

define i32 @t8_nuw(i32 %x, i32 %nbits) {
; CHECK-LABEL: @t8_nuw(
; CHECK-NEXT:    [[T0:%.*]] = shl i32 -1, [[NBITS:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = lshr i32 [[T0]], [[NBITS]]
; CHECK-NEXT:    [[T2:%.*]] = and i32 [[T1]], [[X:%.*]]
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    [[T3:%.*]] = shl i32 [[X]], [[NBITS]]
; CHECK-NEXT:    ret i32 [[T3]]
;
  %t0 = shl i32 -1, %nbits
  %t1 = lshr i32 %t0, %nbits
  %t2 = and i32 %t1, %x
  call void @use32(i32 %t0)
  call void @use32(i32 %t1)
  call void @use32(i32 %t2)
  %t3 = shl nuw i32 %t2, %nbits
  ret i32 %t3
}

define i32 @t9_nsw(i32 %x, i32 %nbits) {
; CHECK-LABEL: @t9_nsw(
; CHECK-NEXT:    [[T0:%.*]] = shl i32 -1, [[NBITS:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = lshr i32 [[T0]], [[NBITS]]
; CHECK-NEXT:    [[T2:%.*]] = and i32 [[T1]], [[X:%.*]]
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    [[T3:%.*]] = shl i32 [[X]], [[NBITS]]
; CHECK-NEXT:    ret i32 [[T3]]
;
  %t0 = shl i32 -1, %nbits
  %t1 = lshr i32 %t0, %nbits
  %t2 = and i32 %t1, %x
  call void @use32(i32 %t0)
  call void @use32(i32 %t1)
  call void @use32(i32 %t2)
  %t3 = shl nsw i32 %t2, %nbits
  ret i32 %t3
}

define i32 @t10_nuw_nsw(i32 %x, i32 %nbits) {
; CHECK-LABEL: @t10_nuw_nsw(
; CHECK-NEXT:    [[T0:%.*]] = shl i32 -1, [[NBITS:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = lshr i32 [[T0]], [[NBITS]]
; CHECK-NEXT:    [[T2:%.*]] = and i32 [[T1]], [[X:%.*]]
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    [[T3:%.*]] = shl i32 [[X]], [[NBITS]]
; CHECK-NEXT:    ret i32 [[T3]]
;
  %t0 = shl i32 -1, %nbits
  %t1 = lshr i32 %t0, %nbits
  %t2 = and i32 %t1, %x
  call void @use32(i32 %t0)
  call void @use32(i32 %t1)
  call void @use32(i32 %t2)
  %t3 = shl nuw nsw i32 %t2, %nbits
  ret i32 %t3
}

; Special test

declare void @llvm.assume(i1 %cond)

; We can't simplify (%shiftnbits-%masknbits) but we have an assumption.
define i32 @t11_assume_uge(i32 %x, i32 %masknbits, i32 %shiftnbits) {
; CHECK-LABEL: @t11_assume_uge(
; CHECK-NEXT:    [[CMP:%.*]] = icmp uge i32 [[SHIFTNBITS:%.*]], [[MASKNBITS:%.*]]
; CHECK-NEXT:    call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    [[T0:%.*]] = shl i32 -1, [[MASKNBITS]]
; CHECK-NEXT:    [[T1:%.*]] = lshr i32 [[T0]], [[MASKNBITS]]
; CHECK-NEXT:    [[T2:%.*]] = and i32 [[T1]], [[X:%.*]]
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    [[T4:%.*]] = shl i32 [[T2]], [[SHIFTNBITS]]
; CHECK-NEXT:    ret i32 [[T4]]
;
  %cmp = icmp uge i32 %shiftnbits, %masknbits
  call void @llvm.assume(i1 %cmp)
  %t0 = shl i32 -1, %masknbits
  %t1 = lshr i32 %t0, %masknbits
  %t2 = and i32 %t1, %x
  call void @use32(i32 %t0)
  call void @use32(i32 %t1)
  call void @use32(i32 %t2)
  %t4 = shl i32 %t2, %shiftnbits
  ret i32 %t4
}

; Negative tests

define i32 @n12_different_shamts0(i32 %x, i32 %nbits0, i32 %nbits1) {
; CHECK-LABEL: @n12_different_shamts0(
; CHECK-NEXT:    [[T0:%.*]] = shl i32 [[X:%.*]], [[NBITS0:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = lshr i32 [[T0]], [[NBITS1:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = and i32 [[T1]], [[X]]
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    [[T3:%.*]] = shl i32 [[T2]], [[NBITS0]]
; CHECK-NEXT:    ret i32 [[T3]]
;
  %t0 = shl i32 %x, %nbits0 ; different shift amts
  %t1 = lshr i32 %t0, %nbits1 ; different shift amts
  %t2 = and i32 %t1, %x
  call void @use32(i32 %t0)
  call void @use32(i32 %t1)
  call void @use32(i32 %t2)
  %t3 = shl i32 %t2, %nbits0
  ret i32 %t3
}

define i32 @n13_different_shamts1(i32 %x, i32 %nbits0, i32 %nbits1) {
; CHECK-LABEL: @n13_different_shamts1(
; CHECK-NEXT:    [[T0:%.*]] = shl i32 [[X:%.*]], [[NBITS0:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = lshr i32 [[T0]], [[NBITS1:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = and i32 [[T1]], [[X]]
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    [[T3:%.*]] = shl i32 [[T2]], [[NBITS1]]
; CHECK-NEXT:    ret i32 [[T3]]
;
  %t0 = shl i32 %x, %nbits0 ; different shift amts
  %t1 = lshr i32 %t0, %nbits1 ; different shift amts
  %t2 = and i32 %t1, %x
  call void @use32(i32 %t0)
  call void @use32(i32 %t1)
  call void @use32(i32 %t2)
  %t3 = shl i32 %t2, %nbits1
  ret i32 %t3
}