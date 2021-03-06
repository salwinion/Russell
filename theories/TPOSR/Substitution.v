Require Import Lambda.TPOSR.Terms.
Require Import Lambda.TPOSR.Reduction.
Require Import Lambda.TPOSR.Conv.
Require Import Lambda.TPOSR.LiftSubst.
Require Import Lambda.TPOSR.Env.
Require Import Lambda.TPOSR.Types.
Require Import Lambda.TPOSR.LeftReflexivity.
Require Import Lambda.TPOSR.Thinning.
Require Import Lambda.TPOSR.CtxReduction.

Require Import Coq.Arith.Lt.

Set Implicit Arguments.

Implicit Types i k m n p : nat.
Implicit Type s : sort.
Implicit Types A B M N T t u v : lterm.
Implicit Types e f g : lenv.

Lemma ind_substitution : 
   (forall e t u U, e |-- t -> u : U ->
   forall g d T, g |-- d -> d : T ->
   forall f n, sub_in_lenv d T n e f -> trunc _ n f g -> 
   f |-- (lsubst_rec d t n) -> (lsubst_rec d u n) : (lsubst_rec d U n)) /\
   (forall e, tposr_wf e ->
   forall g d T, g |-- d -> d : T ->
   forall n f, sub_in_lenv d T n e f -> trunc _ n f g -> 
   tposr_wf f) /\
   (forall e t u s, e |-- t ~= u : s ->
   forall g d T, g |-- d -> d : T ->
   forall f n, sub_in_lenv d T n e f -> trunc _ n f g -> 
   f |-- (lsubst_rec d t n) ~= (lsubst_rec d u n) : s) /\
   (forall e t u s, e |-- t >-> u : s ->
   forall g d T, g |-- d -> d : T ->
   forall f n, sub_in_lenv d T n e f -> trunc _ n f g -> 
   f |-- (lsubst_rec d t n) >-> (lsubst_rec d u n) : s).
Proof.
apply ind_tposr_wf_eq_coerce with
   (P:=fun e t u U => fun H : e |-- t -> u : U =>
   forall g d T, g |-- d -> d : T ->
   forall f n, sub_in_lenv d T n e f -> trunc _ n f g -> 
   f |-- (lsubst_rec d t n) -> (lsubst_rec d u n) : (lsubst_rec d U n))
   (P0:= fun e => fun H : tposr_wf e =>
   forall g d T, g |-- d -> d : T ->
   forall n f, sub_in_lenv d T n e f -> trunc _ n f g -> 
   tposr_wf f)
   (P1 := fun e t u s => fun H : e |-- t ~= u : s =>
   forall g d T, g |-- d -> d : T ->
   forall f n, sub_in_lenv d T n e f -> trunc _ n f g -> 
   f |-- (lsubst_rec d t n) ~= (lsubst_rec d u n) : s)
   (P2 := fun e t u s => fun H : e |-- t >-> u : s =>
   forall g d T, g |-- d -> d : T ->
   forall f n, sub_in_lenv d T n e f -> trunc _ n f g -> 
   f |-- (lsubst_rec d t n) >-> (lsubst_rec d u n) : s);
   simpl in |- *;
   intros; auto with coc core arith datatypes.

elim (lt_eq_lt_dec n0 n); [ intro Hlt_eq | intro Hlt ].
elim i.
elim Hlt_eq; clear Hlt_eq.
case n; [ intro Hlt | intros n1 Hlt ]; intros.
inversion_clear Hlt.

simpl in |- *.
rewrite H3.
rewrite simpl_lsubst; auto with coc core arith datatypes.
apply tposr_var; auto with coc core arith datatypes.
apply (H _ _ _ H0 _ _ H1) ; auto.
exists x; auto with coc core arith datatypes.
apply nth_sub_sup with d T0 n0 e; auto with coc core arith datatypes.

intro Heq; intros.
rewrite H3.
elim Heq.
rewrite simpl_lsubst; auto with coc core arith datatypes.
replace x with T0.
apply thinning_n with g; auto with coc core arith datatypes.
subst.
apply (H _ _ _ H0 _ _ H1) ; auto.

apply fun_item with e n; auto with coc core arith datatypes.
apply nth_sub_eq with d f; auto with coc core arith datatypes.
elim Heq; auto with coc core arith datatypes.

apply tposr_var; auto with coc core arith datatypes.
apply (H _ _ _ H0 _ _ H1) ; auto.
apply nth_sub_inf with T0 e; auto with coc core arith datatypes.

apply tposr_set ; eauto with coc.

apply tposr_prop ; eauto with coc.

apply tposr_prod with s1 ; eauto with coc ecoc core arith datatypes.

apply tposr_abs with s1 (lsubst_rec d B' (S n)) s2 ; eauto with coc core arith datatypes.

rewrite distr_lsubst ; auto with coc.
apply tposr_app with (lsubst_rec d A n) (lsubst_rec d A' n) s1 s2; eauto with coc core arith datatypes.
assert(sub_in_lenv d T (S n) (A :: e) (lsubst_rec d A n :: f)).
apply sub_S ; auto with coc.
assert(trunc lterm (S n) (lsubst_rec d A n :: f) g).
apply trunc_S ; auto with coc.
pose (H0 _ _ _ H3 _ _ H6 H7) ; auto with coc.

rewrite distr_lsubst ; auto with coc.
rewrite distr_lsubst ; auto with coc.
apply tposr_beta with (lsubst_rec d A' n) s1  (lsubst_rec d B' (S n)) s2; eauto with coc core arith datatypes.

apply tposr_conv with (lsubst_rec d A n) s; eauto with coc.

apply tposr_subset ; eauto with coc.

apply tposr_sum with s1 s2; eauto with coc core arith datatypes.

apply tposr_pair with s1 s2 s3 ; eauto with coc.
rewrite <- distr_lsubst ; eauto with coc.

pose (H _ _ _ H3 _ _ H4 H5).
apply tposr_pi1 with s1 s2 s3 ; eauto with coc.

apply tposr_pi1_red with (lsubst_rec d A' n) s1 (lsubst_rec d B' (S n)) s2 s3 (lsubst_rec d v' n); eauto with coc.

rewrite distr_lsubst.
simpl.
pose (H _ _ _ H3 _ _ H4 H5).
apply tposr_pi2 with s1 s2 s3 ; eauto with coc.

rewrite distr_lsubst.
simpl.
apply tposr_pi2_red with  (lsubst_rec d A' n) s1 (lsubst_rec d B' (S n)) s2 s3  (lsubst_rec d u' n); eauto with coc.

inversion H0.
inversion H1 ; subst.
apply (wf_tposr t).
inversion H2.
apply wf_cons with s ; apply (H _ _ _ H0 _ _ H7 H8).

apply tposr_eq_tposr ; eauto with coc.
eauto with coc ecoc.

apply tposr_eq_trans with (lsubst_rec d X n) ; eauto with coc.

pose (H _ _ _ H0 _ _ H1 H2).
auto with coc.

apply tposr_coerce_prod with s ; eauto with coc.

apply tposr_coerce_sum with s s' ; eauto with coc.

apply tposr_coerce_sub_l ; eauto with coc.

apply tposr_coerce_sub_r ; eauto with coc.

eauto with coc.

apply tposr_coerce_trans with (lsubst_rec d B n) ; eauto with coc.
Qed.

Corollary substitution_tposr_n : forall g d t, g |-- d -> d : t ->
   forall e u v U, e |-- u -> v : U ->
   forall f n, sub_in_lenv d t n e f -> trunc _ n f g -> 
   f |-- (lsubst_rec d u n) -> (lsubst_rec d v n) : (lsubst_rec d U n).
Proof.
  intros.
  eapply (proj1 (ind_substitution)) ; eauto with coc.
Qed.

Corollary substitution_tposr_wf_n : forall g d t, g |-- d -> d : t ->
   forall e, tposr_wf e -> forall f n, sub_in_lenv d t n e f -> 
   trunc _ n f g -> tposr_wf f.
Proof.
  intros.
  eapply (proj1 (proj2 (ind_substitution))) ; eauto with coc.
Qed.

Corollary substitution_eq_n : forall g d t, g |-- d -> d : t ->
   forall e u v s, e |-- u ~= v : s ->
   forall f n, sub_in_lenv d t n e f -> trunc _ n f g -> 
   f |-- (lsubst_rec d u n) ~= (lsubst_rec d v n) : s.
Proof.
  intros.
  eapply (proj1 (proj2 (proj2 (ind_substitution)))) ; eauto with coc.
Qed.

Corollary substitution_coerce_n : forall g d t, g |-- d -> d : t ->
   forall e u v s, e |-- u >-> v : s ->
   forall f n, sub_in_lenv d t n e f -> trunc _ n f g -> 
   f |-- (lsubst_rec d u n) >-> (lsubst_rec d v n) : s.
Proof.
  intros.
  eapply (proj2 (proj2 (proj2 (ind_substitution)))) ; eauto with coc.
Qed.

Corollary substitution : forall e t u v U, (t :: e) |-- u -> v : U ->
  forall d, e |-- d -> d : t -> e |-- (lsubst d u) -> (lsubst d v) : (lsubst d U).
Proof.
  intros ; unfold lsubst ; eapply substitution_tposr_n ; eauto with coc.
Qed.

Corollary substitution_eq : 
   forall e t u v s, t :: e |-- u ~= v : s ->
   forall d, e |-- d -> d : t ->
   e |-- (lsubst d u) ~= (lsubst d v) : s.
Proof.
  intros ; unfold lsubst ; eapply substitution_eq_n ; eauto with coc.
Qed.

Corollary substitution_coerce : 
   forall e t u v s, t :: e |-- u >-> v : s ->
   forall d, e |-- d -> d : t ->
   e |-- (lsubst d u) >-> (lsubst d v) : s.
Proof.
  intros ; unfold lsubst ; eapply substitution_coerce_n ; eauto with coc.
Qed.

Corollary substitution_tposrp_aux : forall G u v U, G |-- u -+> v : U -> forall t e, G = (t :: e) ->
  forall d, e |-- d -> d : t -> e |-- (lsubst d u) -+> (lsubst d v) : (lsubst d U).
Proof.
  induction 1 ; simpl ; intros; subst ; eauto with coc ecoc.
  apply tposrp_tposr.
  apply substitution with t ; auto.
Qed.

Corollary substitution_tposrp : forall t e u v U, t :: e |-- u -+> v : U -> 
  forall d, e |-- d -> d : t -> e |-- (lsubst d u) -+> (lsubst d v) : (lsubst d U).
Proof.
  intros.
  eapply substitution_tposrp_aux  ; eauto with coc.
Qed.

Corollary substitution_sorted_n : 
  forall g d t, g |-- d -> d : t ->
   forall e u v s, e |-- u -> v : s ->
   forall f n, sub_in_lenv d t n e f -> trunc _ n f g -> 
   f |-- (lsubst_rec d u n) -> (lsubst_rec d v n) : Srt_l s.
Proof.
  intros.
  change (Srt_l s) with (lsubst_rec d (Srt_l s) n).
  eapply substitution_tposr_n ; eauto with coc.
Qed.

Corollary substitution_sorted : forall e t u v s, (t :: e) |-- u -> v : Srt_l s ->
  forall d, e |-- d -> d : t -> e |-- (lsubst d u) -> (lsubst d v) : Srt_l s.
Proof.
  intros.
  change (Srt_l s) with (lsubst d (Srt_l s)).
  apply substitution with t ; auto.
Qed.

Hint Resolve substitution substitution_coerce substitution_eq substitution_tposrp : ecoc.
