; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; ModuleID = 'reduced.ll'
; RUN: opt < %s -loop-unroll -verify-loop-lcssa -S | FileCheck %s

source_filename = "reduced.ll"

%"class.std::__Cr::basic_ostream" = type { i32 (...)**, %"class.std::__Cr::basic_ios" }
%"class.std::__Cr::basic_ios" = type { %"class.std::__Cr::ios_base", %"class.std::__Cr::basic_ostream"*, i32 }
%"class.std::__Cr::ios_base" = type { i32 (...)**, i32, i32, i32, i32, i32, i8*, i8*, void (i32, %"class.std::__Cr::ios_base"*, i32)**, i32*, i32, i32, i32*, i32, i32, i8**, i32, i32 }
%"class.v8::internal::wasm::StructType" = type { i32, i32*, %"class.v8::internal::wasm::ValueType"*, i8* }
%"class.v8::internal::wasm::ValueType" = type { i32 }

$_ZNK2v88internal4wasm10StructType12field_offsetEj = comdat any

declare hidden %"class.std::__Cr::basic_ostream"* @_ZNSt4__CrlsINS_11char_traitsIcEEEERNS_13basic_ostreamIcT_EES6_PKc() local_unnamed_addr

define hidden void @_ZN2v88internal10WasmStruct15WasmStructPrintERNSt4__Cr13basic_ostreamIcNS2_11char_traitsIcEEEE() local_unnamed_addr align 2 {
; CHECK-LABEL: @_ZN2v88internal10WasmStruct15WasmStructPrintERNSt4__Cr13basic_ostreamIcNS2_11char_traitsIcEEEE(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CALL61:%.*]] = tail call i32 @_ZNK2v88internal4wasm10StructType11field_countEv()
; CHECK-NEXT:    [[CMP2_NOT:%.*]] = icmp eq i32 [[CALL61]], 0
; CHECK-NEXT:    br i1 [[CMP2_NOT]], label [[FOR_COND_CLEANUP:%.*]], label [[FOR_BODY_PREHEADER:%.*]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    br label [[FOR_BODY_PEEL_BEGIN:%.*]]
; CHECK:       for.body.peel.begin:
; CHECK-NEXT:    br label [[FOR_BODY_PEEL:%.*]]
; CHECK:       for.body.peel:
; CHECK-NEXT:    tail call void @llvm.assume(i1 true)
; CHECK-NEXT:    [[CALL13_PEEL:%.*]] = tail call i8 @_ZNK2v88internal4wasm9ValueType4kindEv()
; CHECK-NEXT:    switch i8 [[CALL13_PEEL]], label [[FOR_INC_PEEL:%.*]] [
; CHECK-NEXT:    i8 5, label [[SW_BB33_PEEL:%.*]]
; CHECK-NEXT:    i8 9, label [[SW_BB31:%.*]]
; CHECK-NEXT:    i8 8, label [[SW_BB31]]
; CHECK-NEXT:    i8 11, label [[SW_BB31]]
; CHECK-NEXT:    i8 10, label [[SW_BB31]]
; CHECK-NEXT:    ]
; CHECK:       sw.bb33.peel:
; CHECK-NEXT:    [[CALL34_PEEL:%.*]] = tail call %"class.std::__Cr::basic_ostream"* @_ZNSt4__CrlsINS_11char_traitsIcEEEERNS_13basic_ostreamIcT_EES6_PKc()
; CHECK-NEXT:    br label [[FOR_INC_PEEL]]
; CHECK:       for.inc.peel:
; CHECK-NEXT:    [[CALL6_PEEL:%.*]] = tail call i32 @_ZNK2v88internal4wasm10StructType11field_countEv()
; CHECK-NEXT:    [[CMP_PEEL:%.*]] = icmp ugt i32 [[CALL6_PEEL]], 1
; CHECK-NEXT:    br i1 [[CMP_PEEL]], label [[FOR_BODY_PEEL_NEXT:%.*]], label [[FOR_COND_CLEANUP_LOOPEXIT:%.*]]
; CHECK:       for.body.peel.next:
; CHECK-NEXT:    br label [[FOR_BODY_PEEL_NEXT1:%.*]]
; CHECK:       for.body.peel.next1:
; CHECK-NEXT:    br label [[FOR_BODY_PREHEADER_PEEL_NEWPH:%.*]]
; CHECK:       for.body.preheader.peel.newph:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.cond.cleanup.loopexit.loopexit:
; CHECK-NEXT:    br label [[FOR_COND_CLEANUP_LOOPEXIT]]
; CHECK:       for.cond.cleanup.loopexit:
; CHECK-NEXT:    br label [[FOR_COND_CLEANUP]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    ret void
; CHECK:       for.body:
; CHECK-NEXT:    tail call void @llvm.assume(i1 false)
; CHECK-NEXT:    [[CALL13:%.*]] = tail call i8 @_ZNK2v88internal4wasm9ValueType4kindEv()
; CHECK-NEXT:    switch i8 [[CALL13]], label [[FOR_INC:%.*]] [
; CHECK-NEXT:    i8 5, label [[SW_BB33:%.*]]
; CHECK-NEXT:    i8 9, label [[SW_BB31_LOOPEXIT:%.*]]
; CHECK-NEXT:    i8 8, label [[SW_BB31_LOOPEXIT]]
; CHECK-NEXT:    i8 11, label [[SW_BB31_LOOPEXIT]]
; CHECK-NEXT:    i8 10, label [[SW_BB31_LOOPEXIT]]
; CHECK-NEXT:    ]
; CHECK:       sw.bb31.loopexit:
; CHECK-NEXT:    br label [[SW_BB31]]
; CHECK:       sw.bb31:
; CHECK-NEXT:    tail call void @_ZN2v84baseL18ReadUnalignedValueINS_8internal6ObjectEEET_j()
; CHECK-NEXT:    unreachable
; CHECK:       sw.bb33:
; CHECK-NEXT:    [[CALL34:%.*]] = tail call %"class.std::__Cr::basic_ostream"* @_ZNSt4__CrlsINS_11char_traitsIcEEEERNS_13basic_ostreamIcT_EES6_PKc()
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       for.inc:
; CHECK-NEXT:    [[CALL6:%.*]] = tail call i32 @_ZNK2v88internal4wasm10StructType11field_countEv()
; CHECK-NEXT:    [[CMP:%.*]] = icmp ugt i32 [[CALL6]], 1
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_COND_CLEANUP_LOOPEXIT_LOOPEXIT:%.*]], !llvm.loop [[LOOP0:![0-9]+]]
;
entry:
  %call61 = tail call i32 @_ZNK2v88internal4wasm10StructType11field_countEv()
  %cmp2.not = icmp eq i32 %call61, 0
  br i1 %cmp2.not, label %for.cond.cleanup, label %for.body.preheader

for.body.preheader:                               ; preds = %entry
  br label %for.body

for.cond.cleanup.loopexit:                        ; preds = %for.inc
  br label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond.cleanup.loopexit, %entry
  ret void

for.body:                                         ; preds = %for.body.preheader, %for.inc
  %cmp.i3 = phi i1 [ false, %for.inc ], [ true, %for.body.preheader ]
  tail call void @llvm.assume(i1 %cmp.i3)
  %call13 = tail call i8 @_ZNK2v88internal4wasm9ValueType4kindEv()
  switch i8 %call13, label %for.inc [
  i8 5, label %sw.bb33
  i8 9, label %sw.bb31
  i8 8, label %sw.bb31
  i8 11, label %sw.bb31
  i8 10, label %sw.bb31
  ]

sw.bb31:                                          ; preds = %for.body, %for.body, %for.body, %for.body
  tail call void @_ZN2v84baseL18ReadUnalignedValueINS_8internal6ObjectEEET_j()
  unreachable

sw.bb33:                                          ; preds = %for.body
  %call34 = tail call %"class.std::__Cr::basic_ostream"* @_ZNSt4__CrlsINS_11char_traitsIcEEEERNS_13basic_ostreamIcT_EES6_PKc()
  br label %for.inc

for.inc:                                          ; preds = %for.body, %sw.bb33
  %call6 = tail call i32 @_ZNK2v88internal4wasm10StructType11field_countEv()
  %cmp = icmp ugt i32 %call6, 1
  br i1 %cmp, label %for.body, label %for.cond.cleanup.loopexit
}

declare hidden i32 @_ZNK2v88internal4wasm10StructType11field_countEv() local_unnamed_addr align 2

define linkonce_odr hidden i32 @_ZNK2v88internal4wasm10StructType12field_offsetEj(%"class.v8::internal::wasm::StructType"* %this, i32 %index) local_unnamed_addr comdat align 2 {
; CHECK-LABEL: @_ZNK2v88internal4wasm10StructType12field_offsetEj(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[INDEX:%.*]], 0
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    ret i32 undef
;
entry:
  %cmp = icmp eq i32 %index, 0
  tail call void @llvm.assume(i1 %cmp)
  ret i32 undef
}

declare hidden i8 @_ZNK2v88internal4wasm9ValueType4kindEv() local_unnamed_addr align 2

declare void @_ZN2v84baseL18ReadUnalignedValueINS_8internal6ObjectEEET_j() local_unnamed_addr

; Function Attrs: inaccessiblememonly nofree nosync nounwind willreturn
declare void @llvm.assume(i1 noundef) #0

attributes #0 = { inaccessiblememonly nofree nosync nounwind willreturn }