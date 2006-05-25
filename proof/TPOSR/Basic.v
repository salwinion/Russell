Require Import Lambda.Terms.
Require Import Lambda.Reduction.
Require Import Lambda.Conv.
Require Import Lambda.LiftSubst.
Require Import Lambda.Env.
Require Import TPOSR.Terms.
Require Import TPOSR.Reduction.
Require Import TPOSR.Conv.
Require Import TPOSR.LiftSubst.
Require Import TPOSR.Env.
Require Import TPOSR.Types.

Set Implicit Arguments.

Lemma wf_tposr : forall e M N T, e |-- M -> N : T -> tposr_wf e.
Proof.
  induction 1 ; simpl ; auto with coc.
Qed.

Lemma tposr_conv : forall e A B s, e |-- A ~= B : s -> 
  forall M N, (e |-- M -> N : A -> e |-- M -> N : B) /\ (e |-- M -> N : B -> e |-- M -> N : A).
Proof.
  induction 1 ; simpl ; intros.
  
  split ; intros.
  apply tposr_red with X s ; auto.
  apply tposr_exp with Y s ; auto.

  pose (IHtposr_eq M N).
  intuition ; auto with coc.

  pose (IHtposr_eq1 M N).
  pose (IHtposr_eq2 M N).
  intuition ; auto with coc.
Qed.

Lemma tposr_lred : forall e M N Z, e |-- M -> N : Z -> lred M N.
Proof.
  induction 1 ; simpl ; auto with coc.

  apply trans_lred with (App_l B' (Abs_l A' M') N') ; auto with coc.
Qed.

Lemma tposr_eq_conv : forall e M N Z, e |-- M ~= N : Z -> conv M N.
Proof.
  induction 1 ; simpl ; auto with coc.
  
  pose (tposr_lred H) ; auto with coc.
  apply trans_conv_conv with X ; auto with coc.
Qed.

Lemma context_validity : forall g, tposr_wf g -> forall n d, trunc _ n g d -> tposr_wf d.
Proof.
  induction g  ; simpl ; auto with coc.
  intros.
  inversion H0 ; auto with coc.

  intros.
  inversion H.
  pose (wf_tposr H2).
  inversion H0.
  rewrite H6 in H0.
  apply wf_cons with A' s ; auto with coc.
  rewrite <- H5 in H0.
  apply (IHg t) with k  ; auto.
Qed.
