Require Import TPOSR.Terms.
Require Import TPOSR.Reduction.
Require Import TPOSR.Conv.
Require Import TPOSR.LiftSubst.
Require Import TPOSR.Env.
Require Import TPOSR.Types.
Require Import TPOSR.Basic.
Require Import TPOSR.CtxReduction.
Require Import TPOSR.RightReflexivity.
Set Implicit Arguments.

Implicit Types i k m n p : nat.
Implicit Type s : sort.
Implicit Types A B M N T t u v : lterm.
Implicit Types e f g : lenv.

Inductive red_in_env : lenv -> lenv -> Prop :=
  | red_env_hd : forall e t u s, e |-- t -> u : Srt_l s ->
	red_in_env (t :: e) (u :: e)
  | red_env_tl :
      forall e f t, red_in_env e f -> red_in_env (t :: e) (t :: f).

Hint Resolve red_env_hd red_env_tl: coc.

Lemma red_env :
  (forall e t u T, e |-- t -> u : T -> 
  forall f, red_in_env e f -> f |-- t -> u : T).
Proof.
Admitted.

Inductive exp_in_env : lenv -> lenv -> Prop :=
  | exp_env_hd : forall e t u s, e |-- t -> u : Srt_l s ->
	exp_in_env (u :: e) (t :: e)
  | exp_env_tl :
      forall e f t, exp_in_env e f -> exp_in_env (t :: e) (t :: f).

Hint Resolve red_env_hd red_env_tl: coc.

Lemma exp_env :
  (forall e t u T, e |-- t -> u : T -> 
  forall f, exp_in_env e f -> f |-- t -> u : T).
Proof.
Admitted.

Inductive conv_in_env : lenv -> lenv -> Prop :=
  | conv_env_hd : forall e t u s, e |-- t ~= u : s -> 
	conv_in_env (t :: e) (u :: e)
  | conv_env_tl :
      forall e f t, conv_in_env e f -> conv_in_env (t :: e) (t :: f).

Hint Resolve conv_env_hd conv_env_tl: coc.

Lemma conv_env :
  (forall e t u T, e |-- t -> u : T -> 
  forall f, conv_in_env e f -> f |-- t -> u : T).
Proof.
Admitted.

Corollary conv_env_eq : 
  (forall e t u s, e |-- t ~= u : s -> 
  forall f, conv_in_env e f -> f |-- t ~= u : s).
Proof.
  induction 1 ; simpl ; intros ; auto with coc.

  apply tposr_eq_tposr ; auto.
  apply conv_env with e ; auto.

  apply tposr_eq_trans with X ; auto with coc.
Qed.

(*
Lemma ind_conv_env :
  (forall e t T, e |-- t : T -> 
  forall f, conv_in_env e f -> f |-- t : T) /\
  (forall e T U s, e |-- T >> U : s -> 
  forall f, conv_in_env e f -> f |-- T >> U : s) /\
  (forall e U V T, e |-- U = V : T ->
  forall f, conv_in_env e f -> f |-- U = V : T).
Proof.
apply typ_coerce_jeq_ind with 
(P := fun e t T => fun H : typ e t T =>
  forall f, conv_in_env e f -> 
  typ f t T)
(P0 := fun e T U s => fun H : e |-- T >> U : s =>
  forall f, conv_in_env e f -> 
  f |-- T >> U : s) 
(P1 := fun e U V T => fun H : e |-- U = V : T =>
  forall f, conv_in_env e f -> 
  f |-- U = V : T) ;
 intros ; try (solve [destruct (H f H0) ; clear H]); 
auto with coc core arith datatypes.

inversion H ; auto with coc.
inversion H ; auto with coc.

inversion H0.
apply type_conv with (lift 1 u) s0 ; auto with coc.
apply type_var with s0 ; auto with coc .
apply coerce_conv ; auto with coc.
change (Srt s0) with (lift 1 (Srt s0)).
apply jeq_weak with s0 ; auto.
apply jeq_sym ; auto.

apply type_var with s ; auto.

inversion H1.
apply type_weak with s0 ; auto.
apply type_weak with s ; auto.

apply type_abs with s1 s2 ; auto with coc.

apply type_app with V ; auto with coc.

apply type_pair with s1 s2 s3 ; auto with coc.

apply type_prod with s1 ; auto with coc.

apply type_sum with s1 s2 ; auto with coc.

apply type_subset ; auto with coc.

apply type_pi1 with V ; auto with coc.

apply type_pi2 with U ; auto with coc.

apply type_conv with U s ; auto with coc.

inversion H1.
apply coerce_weak with s0 ; auto with coc.
apply coerce_weak with s' ; auto with coc.

apply coerce_prod with s ; auto with coc.

apply coerce_sum with s s' ; auto with coc.

apply coerce_trans with B ; auto with coc.

inversion H1.
apply jeq_weak with s0 ; auto with coc.
apply jeq_weak with s ; auto with coc.

apply jeq_prod with s1 ; auto with coc.

apply jeq_abs with s1 s2 ; auto with coc.

apply jeq_app with A ; auto with coc.

apply jeq_beta with s1 s2 ; auto with coc.

apply jeq_red with A s ; auto with coc.

apply jeq_exp with B s ; auto with coc.

apply jeq_sum with s1 s2 ; auto with coc.

apply jeq_pair with s1 s2 s3; auto with coc.

apply jeq_pi1 with  B; auto with coc.

apply jeq_pi1_red with s1 s2 s3; auto with coc.

apply jeq_pi2 with A ; auto with coc.

apply jeq_pi2_red with s1 s2 s3 ; auto with coc.

apply jeq_subset ; auto with coc.

apply jeq_trans with N ; auto with coc.

apply jeq_conv with A s ; auto with coc.
Qed.

Lemma type_conv_env : forall e t T, e |-- t : T -> 
  forall f, conv_in_env e f -> f |-- t : T.
Proof (proj1 ind_conv_env).

Lemma coerce_conv_env : forall e T U s, e |-- T >> U : s -> 
  forall f, conv_in_env e f -> f |-- T >> U : s.
Proof (proj1 (proj2 ind_conv_env)).

Lemma jeq_conv_env : forall e U V T, e |-- U = V : T ->
  forall f, conv_in_env e f -> f |-- U = V : T.
Proof (proj2 (proj2 ind_conv_env)).

*)