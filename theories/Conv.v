Require Import Lambda.Terms.
Require Import Lambda.LiftSubst.
Require Import Lambda.Reduction.

Implicit Types i k m n p : nat.
Implicit Type s : sort.
Implicit Types A B M N T t u v : term.

Section Church_Rosser.

  Definition str_confluent (R : term -> term -> Prop) :=
    commut _ R (transp _ R).

  Lemma str_confluence_par_red1 : str_confluent par_red1.
red ; red.
intros x y H ; induction H ; intros.
inversion_clear H1.
elim IHpar_red1_1 with M'0; auto with coc core arith sets; intros.
elim IHpar_red1_2 with N'0; auto with coc core arith sets; intros.
exists (subst x0 x); unfold subst in |- *; auto with coc core arith sets.

inversion_clear H2.
elim IHpar_red1_1 with M'1; auto with coc core arith sets; intros.
elim IHpar_red1_2 with N'0; auto with coc core arith sets; intros.
exists (subst x0 x); auto with coc core arith sets; unfold subst in |- *;
 auto with coc core arith sets.

inversion_clear H0.
apply IHpar_red1 ; auto.

unfold transp.
inversion_clear H1.
unfold transp.
induction (IHpar_red1 M'1).
exists x ;  auto with coc core arith sets.
assumption.

inversion_clear H0.
apply IHpar_red1 ; auto.

inversion_clear H1.
induction (IHpar_red1 N'0).
exists x ;  auto with coc core arith sets.
assumption.

inversion_clear H.
exists (Srt s); auto with coc core arith sets.

inversion_clear H.
exists (Ref n); auto with coc core arith sets.

inversion_clear H1.
elim IHpar_red1_1 with M'0; auto with coc core arith sets; intros.
elim IHpar_red1_2 with T'0; auto with coc core arith sets; intros.
exists (Abs x0 x); auto with coc core arith sets.

generalize H IHpar_red1_1.
clear H IHpar_red1_1.
inversion_clear H1.
intro.
inversion_clear H1.
intros.
elim IHpar_red1_1 with (Abs T M'0); auto with coc core arith sets; intros.
elim IHpar_red1_2 with N'0; auto with coc core arith sets; intros.
apply inv_par_red_abs with T' M'1 x; intros; auto with coc core arith sets.
generalize H1 H5.
rewrite H8.
clear H1 H5; intros.
inversion_clear H1.
inversion_clear H5.
exists (subst x0 U'); auto with coc core arith sets.
unfold subst in |- *; auto with coc core arith sets.

intros.
elim IHpar_red1_1 with M'0; auto with coc core arith sets; intros.
elim IHpar_red1_2 with N'0; auto with coc core arith sets; intros.
exists (App x x0); auto with coc core arith sets.

intros.
inversion_clear H2.
elim IHpar_red1_1 with T'0; auto with coc core arith sets; intros.
elim IHpar_red1_2 with M'0; auto with coc core arith sets; intros.
elim IHpar_red1_3 with N'0; auto with coc core arith sets; intros.
exists (Pair x x0 x1); auto with coc core arith sets.

intros.
inversion_clear H1.
elim IHpar_red1_1 with M'0; auto with coc core arith sets; intros.
elim IHpar_red1_2 with N'0; auto with coc core arith sets; intros.
exists (Prod x x0); auto with coc core arith sets.


intros.
inversion_clear H1.
elim IHpar_red1_1 with M'0; auto with coc core arith sets; intros.
elim IHpar_red1_2 with N'0; auto with coc core arith sets; intros.
exists (Sum x x0); auto with coc core arith sets.


intros.
inversion_clear H1.
elim IHpar_red1_1 with M'0; auto with coc core arith sets; intros.
elim IHpar_red1_2 with N'0; auto with coc core arith sets; intros.
exists (Subset x x0); auto with coc core arith sets.

generalize H IHpar_red1.
clear H IHpar_red1.
inversion_clear H0.
intro.
inversion_clear H0.
intros.
elim IHpar_red1 with (Pair T' z N') ; auto with coc core arith sets; intros.
apply inv_par_red_pair with T' z N' x; intros; auto with coc core arith sets.
generalize H0 H4.
rewrite H5.
clear H0 H4 ; intros.
inversion_clear H0.
inversion_clear H4.
exists U' ; auto with coc core arith sets.

intros.
elim IHpar_red1 with M'0.
intros.
exists (Pi1 x) ; auto with coc core arith sets.
assumption.


generalize H IHpar_red1.
clear H IHpar_red1.
inversion_clear H0.
intro.
inversion_clear H0.
intros.
elim IHpar_red1 with (Pair T' M'0 z) ; auto with coc core arith sets; intros.
apply inv_par_red_pair with T' M'0 z x; intros; auto with coc core arith sets.
generalize H0 H4.
rewrite H5.
clear H0 H4 ; intros.
inversion_clear H0.
inversion_clear H4.
exists V' ; auto with coc core arith sets.

intros.
elim IHpar_red1 with M'0.
intros.
exists (Pi2 x) ; auto with coc core arith sets.
assumption.
Qed.

  Lemma strip_lemma : commut _ par_red (transp _ par_red1).
unfold commut, par_red in |- *; simple induction 1; intros.
elim str_confluence_par_red1 with z x0 y0; auto with coc core arith sets;
 intros.
exists x1; auto with coc core arith sets.

elim H1 with z0; auto with coc core arith sets; intros.
elim H3 with x1; intros; auto with coc core arith sets.
exists x2; auto with coc core arith sets.
apply t_trans with x1; auto with coc core arith sets.
Qed.


  Lemma confluence_par_red : str_confluent par_red.
red in |- *; red in |- *.
simple induction 1; intros.
elim strip_lemma with z x0 y0; intros; auto with coc core arith sets.
exists x1; auto with coc core arith sets.

elim H1 with z0; intros; auto with coc core arith sets.
elim H3 with x1; intros; auto with coc core arith sets.
exists x2; auto with coc core arith sets.
red in |- *.
apply t_trans with x1; auto with coc core arith sets.
Qed.


  Lemma confluence_red : str_confluent red.
red in |- *; red in |- *.
intros.
elim confluence_par_red with x y z; auto with coc core arith sets; intros.
exists x0; auto with coc core arith sets.
Qed.


  Theorem church_rosser :
   forall u v, conv u v -> ex2 (fun t => red u t) (fun t => red v t).
simple induction 1; intros.
exists u; auto with coc core arith sets.

elim H1; intros.
elim confluence_red with x P N; auto with coc core arith sets; intros.
exists x0; auto with coc core arith sets.
apply trans_red_red with x; auto with coc core arith sets.

elim H1; intros.
exists x; auto with coc core arith sets.
apply trans_red_red with P; auto with coc core arith sets.
Qed.



  Lemma inv_conv_prod_l :
   forall a b c d : term, conv (Prod a c) (Prod b d) -> conv a b.
intros.
elim church_rosser with (Prod a c) (Prod b d); intros;
 auto with coc core arith sets.
apply red_prod_prod with a c x; intros; auto with coc core arith sets.
apply red_prod_prod with b d x; intros; auto with coc core arith sets.
apply trans_conv_conv with a0; auto with coc core arith sets.
apply sym_conv.
generalize H2.
rewrite H5; intro.
injection H8.
simple induction 2; auto with coc core arith sets.
Qed.

  Lemma inv_conv_prod_r :
   forall a b c d : term, conv (Prod a c) (Prod b d) -> conv c d.
intros.
elim church_rosser with (Prod a c) (Prod b d); intros;
 auto with coc core arith sets.
apply red_prod_prod with a c x; intros; auto with coc core arith sets.
apply red_prod_prod with b d x; intros; auto with coc core arith sets.
apply trans_conv_conv with b0; auto with coc core arith sets.
apply sym_conv.
generalize H2.
rewrite H5; intro.
injection H8.
simple induction 1; auto with coc core arith sets.
Qed.

  Lemma inv_conv_sum_l :
   forall a b c d : term, conv (Sum a c) (Sum b d) -> conv a b.
intros.
elim church_rosser with (Sum a c) (Sum b d); intros;
 auto with coc core arith sets.
apply red_sum_sum with a c x; intros; auto with coc core arith sets.
apply red_sum_sum with b d x; intros; auto with coc core arith sets.
apply trans_conv_conv with a0; auto with coc core arith sets.
apply sym_conv.
generalize H2.
rewrite H5; intro.
injection H8.
simple induction 2; auto with coc core arith sets.
Qed.


Lemma inv_conv_sum_r :
   forall a b c d : term, conv (Sum a c) (Sum b d) -> conv c d.
intros.
elim church_rosser with (Sum a c) (Sum b d); intros;
 auto with coc core arith sets.
apply red_sum_sum with a c x; intros; auto with coc core arith sets.
apply red_sum_sum with b d x; intros; auto with coc core arith sets.
apply trans_conv_conv with b0; auto with coc core arith sets.
apply sym_conv.
generalize H2.
rewrite H5; intro.
injection H8.
simple induction 1; auto with coc core arith sets.
Qed.


Lemma inv_conv_subset_l :
   forall a b c d : term, conv (Subset a c) (Subset b d) -> conv a b.
intros.
elim church_rosser with (Subset a c) (Subset b d); intros;
 auto with coc core arith sets.
apply red_subset_subset with a c x; intros; auto with coc core arith sets.
apply red_subset_subset with b d x; intros; auto with coc core arith sets.
apply trans_conv_conv with a0; auto with coc core arith sets.
apply sym_conv.
generalize H2.
rewrite H5; intro.
injection H8.
simple induction 2; auto with coc core arith sets.
Qed.


Lemma inv_conv_subset_r :
   forall a b c d : term, conv (Subset a c) (Subset b d) -> conv c d.
intros.
elim church_rosser with (Subset a c) (Subset b d); intros;
 auto with coc core arith sets.
apply red_subset_subset with a c x; intros; auto with coc core arith sets.
apply red_subset_subset with b d x; intros; auto with coc core arith sets.
apply trans_conv_conv with b0; auto with coc core arith sets.
apply sym_conv.
generalize H2.
rewrite H5; intro.
injection H8.
simple induction 1; auto with coc core arith sets.
Qed.



  Lemma nf_uniqueness : forall u v, conv u v -> normal u -> normal v -> u = v. 
intros.
elim church_rosser with u v; intros; auto with coc core arith sets.
rewrite (red_normal u x); auto with coc core arith sets.
elim red_normal with v x; auto with coc core arith sets.
Qed.


  Lemma conv_sort : forall s1 s2, conv (Srt s1) (Srt s2) -> s1 = s2.
intros.
cut (Srt s1 = Srt s2); intros.
injection H0; auto with coc core arith sets.

apply nf_uniqueness; auto with coc core arith sets.
red in |- *; red in |- *; intros.
inversion_clear H0.

red in |- *; red in |- *; intros.
inversion_clear H0.
Qed.


  Lemma conv_kind_prop : ~ conv (Srt kind) (Srt prop).
red in |- *; intro.
absurd (kind = prop).
discriminate.

apply conv_sort; auto with coc core arith sets.
Qed.

  Lemma conv_kind_set : ~ conv (Srt kind) (Srt set).
red in |- *; intro.
absurd (kind = set).
discriminate.

apply conv_sort; auto with coc core arith sets.
Qed.

Lemma conv_sort_ref : forall s n, ~ conv (Srt s) (Ref n).
red in |- *; intros.
elim church_rosser with (Srt s) (Ref n); auto with coc core arith sets.
do 2 intro.
elim red_normal with (Srt s) x; auto with coc core arith sets.
intro.
apply red_ref_ref with n (Srt s); auto with coc core arith sets; intros.
unfold not ; intros ; discriminate H2.

red in |- *; red in |- *; intros.
inversion_clear H1.
Qed.


  Lemma conv_sort_prod : forall s t u, ~ conv (Srt s) (Prod t u).
red in |- *; intros.
elim church_rosser with (Srt s) (Prod t u); auto with coc core arith sets.
do 2 intro.
elim red_normal with (Srt s) x; auto with coc core arith sets.
intro.
apply red_prod_prod with t u (Srt s); auto with coc core arith sets; intros.
discriminate H2.

red in |- *; red in |- *; intros.
inversion_clear H1.
Qed.

  Lemma conv_sort_sum : forall s t u, ~ conv (Srt s) (Sum t u).
red in |- *; intros.
elim church_rosser with (Srt s) (Sum t u); auto with coc core arith sets.
do 2 intro.
elim red_normal with (Srt s) x; auto with coc core arith sets.
intro.
apply red_sum_sum with t u (Srt s); auto with coc core arith sets; intros.
discriminate H2.

red in |- *; red in |- *; intros.
inversion_clear H1.
Qed.

  Lemma conv_sort_subset : forall s t u, ~ conv (Srt s) (Subset t u).
red in |- *; intros.
elim church_rosser with (Srt s) (Subset t u); auto with coc core arith sets.
do 2 intro.
elim red_normal with (Srt s) x; auto with coc core arith sets.
intro.
apply red_subset_subset with t u (Srt s); auto with coc core arith sets; intros.
discriminate H2.

red in |- *; red in |- *; intros.
inversion_clear H1.
Qed.

  Lemma conv_ref_prod : forall n t u, ~ conv (Ref n) (Prod t u).
red in |- *; intros.
elim church_rosser with (Ref n) (Prod t u); auto with coc core arith sets.
do 2 intro.
elim red_normal with (Ref n) x; auto with coc core arith sets.
intro.
apply red_prod_prod with t u (Ref n); auto with coc core arith sets; intros.
discriminate H2.

red in |- *; red in |- *; intros.
inversion_clear H1.
Qed.


  Lemma conv_ref_sum : forall n t u, ~ conv (Ref n) (Sum t u).
red in |- *; intros.
elim church_rosser with (Ref n) (Sum t u); auto with coc core arith sets.
do 2 intro.
elim red_normal with (Ref n) x; auto with coc core arith sets.
intro.
apply red_sum_sum with t u (Ref n); auto with coc core arith sets; intros.
discriminate H2.

red in |- *; red in |- *; intros.
inversion_clear H1.
Qed.

  Lemma conv_ref_subset : forall n t u, ~ conv (Ref n) (Subset t u).
red in |- *; intros.
elim church_rosser with (Ref n) (Subset t u); auto with coc core arith sets.
do 2 intro.
elim red_normal with (Ref n) x; auto with coc core arith sets.
intro.
apply red_subset_subset with t u (Ref n); auto with coc core arith sets; intros.
discriminate H2.

red in |- *; red in |- *; intros.
inversion_clear H1.
Qed.

  Lemma conv_prod_abs : forall U V t u, ~ conv (Prod U V) (Abs t u).
red in |- *; intros.
elim church_rosser with (Prod U V) (Abs t u); auto with coc core arith sets.
intros.

inversion H0 ; inversion H1.
rewrite <- H3 in H2 ; discriminate.

apply red_abs_abs with t u P ; auto with coc core.
intros.
rewrite H6 in H4.
rewrite <- H2 in H4.
inversion H4.

apply red_prod_prod with U V P ; auto with coc core.
intros.
rewrite H6 in H3.
rewrite <- H5 in H3.
inversion H3.

apply red_prod_prod with U V P ; auto with coc core ; intros.
apply red_abs_abs with t u P0 ; auto with coc core ; intros.
rewrite H11 in H6.
rewrite H8 in H3.

inversion H6.
rewrite <- H15 in H3.
inversion H3.

rewrite <- H15 in H3.
inversion H3.
Qed.

  Lemma conv_prod_pair : forall U V t u v, ~ conv (Prod U V) (Pair t u v).
red in |- *; intros.
elim church_rosser with (Prod U V) (Pair t u v); auto with coc core arith sets.
intros.

inversion H0 ; inversion H1.
rewrite <- H3 in H2 ; discriminate.

apply red_pair_pair with t u v P ; auto with coc core.
intros.
rewrite H6 in H4.
rewrite <- H2 in H4.
inversion H4.

apply red_prod_prod with U V P ; auto with coc core.
intros.
rewrite H6 in H3.
rewrite <- H5 in H3.
inversion H3.

apply red_prod_prod with U V P ; auto with coc core ; intros.
apply red_pair_pair with t u v P0 ; auto with coc core ; intros.
rewrite H11 in H6.
rewrite H8 in H3.

inversion H6.
rewrite <- H16 in H3.
inversion H3.

rewrite <- H16 in H3.
inversion H3.

rewrite <- H16 in H3.
inversion H3.
Qed.

  Lemma conv_prod_subset : forall U V t u, ~ conv (Prod U V) (Subset t u).
red in |- *; intros.
elim church_rosser with (Prod U V) (Subset t u); auto with coc core arith sets.
intros.

inversion H0 ; inversion H1.
rewrite <- H3 in H2 ; discriminate.

apply red_subset_subset with t u P ; auto with coc core.
intros.
rewrite H6 in H4.
rewrite <- H2 in H4.
inversion H4.

apply red_prod_prod with U V P ; auto with coc core.
intros.
rewrite H6 in H3.
rewrite <- H5 in H3.
inversion H3.

apply red_prod_prod with U V P ; auto with coc core ; intros.
apply red_subset_subset with t u P0 ; auto with coc core ; intros.
rewrite H11 in H6.
rewrite H8 in H3.

inversion H6.
rewrite <- H15 in H3.
inversion H3.

rewrite <- H15 in H3.
inversion H3.
Qed.

  Lemma conv_prod_sum : forall U V t u, ~ conv (Prod U V) (Sum t u).
red in |- *; intros.
elim church_rosser with (Prod U V) (Sum t u); auto with coc core arith sets.
intros.

inversion H0 ; inversion H1.
rewrite <- H3 in H2 ; discriminate.

apply red_sum_sum with t u P ; auto with coc core.
intros.
rewrite H6 in H4.
rewrite <- H2 in H4.
inversion H4.

apply red_prod_prod with U V P ; auto with coc core.
intros.
rewrite H6 in H3.
rewrite <- H5 in H3.
inversion H3.

apply red_prod_prod with U V P ; auto with coc core ; intros.
apply red_sum_sum with t u P0 ; auto with coc core ; intros.
rewrite H11 in H6.
rewrite H8 in H3.

inversion H6.
rewrite <- H15 in H3.
inversion H3.

rewrite <- H15 in H3.
inversion H3.
Qed.

  Lemma conv_subset_sum : forall U V t u, ~ conv (Subset U V) (Sum t u).
red in |- *; intros.
elim church_rosser with (Subset U V) (Sum t u); auto with coc core arith sets.
intros.

inversion H0 ; inversion H1.
rewrite <- H3 in H2 ; discriminate.

apply red_sum_sum with t u P ; auto with coc core.
intros.
rewrite H6 in H4.
rewrite <- H2 in H4.
inversion H4.

apply red_subset_subset with U V P ; auto with coc core.
intros.
rewrite H6 in H3.
rewrite <- H5 in H3.
inversion H3.

apply red_subset_subset with U V P ; auto with coc core ; intros.
apply red_sum_sum with t u P0 ; auto with coc core ; intros.
rewrite H11 in H6.
rewrite H8 in H3.

inversion H6.
rewrite <- H15 in H3.
inversion H3.

rewrite <- H15 in H3.
inversion H3.
Qed.

  Lemma conv_sum_abs : forall U V t u, ~ conv (Sum U V) (Abs t u).
red in |- *; intros.
elim church_rosser with (Sum U V) (Abs t u); auto with coc core arith sets.
intros.

inversion H0 ; inversion H1.
rewrite <- H3 in H2 ; discriminate.

apply red_abs_abs with t u P ; auto with coc core.
intros.
rewrite H6 in H4.
rewrite <- H2 in H4.
inversion H4.

apply red_sum_sum with U V P ; auto with coc core.
intros.
rewrite H6 in H3.
rewrite <- H5 in H3.
inversion H3.

apply red_sum_sum with U V P ; auto with coc core ; intros.
apply red_abs_abs with t u P0 ; auto with coc core ; intros.
rewrite H11 in H6.
rewrite H8 in H3.

inversion H6.
rewrite <- H15 in H3.
inversion H3.

rewrite <- H15 in H3.
inversion H3.
Qed.

  Lemma conv_sum_pair : forall U V t u v, ~ conv (Sum U V) (Pair t u v).
red in |- *; intros.
elim church_rosser with (Sum U V) (Pair t u v); auto with coc core arith sets.
intros.

inversion H0 ; inversion H1.
rewrite <- H3 in H2 ; discriminate.

apply red_pair_pair with t u v P ; auto with coc core.
intros.
rewrite H6 in H4.
rewrite <- H2 in H4.
inversion H4.

apply red_sum_sum with U V P ; auto with coc core.
intros.
rewrite H6 in H3.
rewrite <- H5 in H3.
inversion H3.

apply red_sum_sum with U V P ; auto with coc core ; intros.
apply red_pair_pair with t u v P0 ; auto with coc core ; intros.
rewrite H11 in H6.
rewrite H8 in H3.

inversion H6.
rewrite <- H16 in H3.
inversion H3.

rewrite <- H16 in H3.
inversion H3.

rewrite <- H16 in H3.
inversion H3.
Qed.

  Lemma conv_subset_abs : forall U V t u, ~ conv (Subset U V) (Abs t u).
red in |- *; intros.
elim church_rosser with (Subset U V) (Abs t u); auto with coc core arith sets.
intros.

inversion H0 ; inversion H1.
rewrite <- H3 in H2 ; discriminate.

apply red_abs_abs with t u P ; auto with coc core.
intros.
rewrite H6 in H4.
rewrite <- H2 in H4.
inversion H4.

apply red_subset_subset with U V P ; auto with coc core.
intros.
rewrite H6 in H3.
rewrite <- H5 in H3.
inversion H3.

apply red_subset_subset with U V P ; auto with coc core ; intros.
apply red_abs_abs with t u P0 ; auto with coc core ; intros.
rewrite H11 in H6.
rewrite H8 in H3.

inversion H6.
rewrite <- H15 in H3.
inversion H3.

rewrite <- H15 in H3.
inversion H3.
Qed.

  Lemma conv_subset_pair : forall U V t u v, ~ conv (Subset U V) (Pair t u v).
red in |- *; intros.
elim church_rosser with (Subset U V) (Pair t u v); auto with coc core arith sets.
intros.

inversion H0 ; inversion H1.
rewrite <- H3 in H2 ; discriminate.

apply red_pair_pair with t u v P ; auto with coc core.
intros.
rewrite H6 in H4.
rewrite <- H2 in H4.
inversion H4.

apply red_subset_subset with U V P ; auto with coc core.
intros.
rewrite H6 in H3.
rewrite <- H5 in H3.
inversion H3.

apply red_subset_subset with U V P ; auto with coc core ; intros.
apply red_pair_pair with t u v P0 ; auto with coc core ; intros.
rewrite H11 in H6.
rewrite H8 in H3.

inversion H6.
rewrite <- H16 in H3.
inversion H3.

rewrite <- H16 in H3.
inversion H3.

rewrite <- H16 in H3.
inversion H3.
Qed.


End Church_Rosser.
