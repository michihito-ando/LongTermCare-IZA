/////////////////////
**save post synth
///////////////////

////////////
*weight
////////////

 
if "_$donor" == "_donors_all"{

*putexcel
putexcel set "post_synth/weight_balance/post_synth_weight_RR_$outcome", replace

*column name
 putexcel B1 =("Synth 1") B2=("Country") C2=("Country ID") D2=("Weght")
 
  *Weights
 matrix list e(W_weights)
 putexcel B3 = matrix(e(W_weights)), rownames
 
}

else if "_$donor" == "_donors_drop1"{

*putexcel
putexcel set "post_synth/weight_balance/post_synth_weight_RR_$outcome", modify

*column name
 putexcel F1 =("Synth 2") F2=("Country") G2=("Country ID") H2=("Weght") // corrected 190119
 
  *Weights
 matrix list e(W_weights)
 putexcel F3 = matrix(e(W_weights)), rownames
}

else if "_$donor" == "_donors_drop2"{

*putexcel
putexcel set "post_synth/weight_balance/post_synth_weight_RR_$outcome", modify

*column name 
 putexcel J1 =("Synth 3") J2=("Country") K2=("Country ID") L2=("Weght") // corrected 190119 => recorrected 200312 (move to left by one line)
 
  *Weights
 matrix list e(W_weights)
 putexcel J3 = matrix(e(W_weights)), rownames
 }

 
////////////
**Covar balance
////////////

 
if "_$donor" == "_donors_all"{

*set
putexcel set "post_synth/weight_balance/post_synth_balance_RR_$outcome", replace

*column name
 putexcel B1=("Synth 1") B2=("Predictor") C2=("Treated") D2=("Synthetic") B40=("RMSPE")   ///
 
*predictor balance
 matrix list e(X_balance)
 putexcel B3=matrix(e(X_balance)), rownames
*RMSPE
 matrix list e(RMSPE)
 putexcel B41=matrix(e(RMSPE))

 
}

else if "_$donor" == "_donors_drop1"{

*set
putexcel set "post_synth/weight_balance/post_synth_balance_RR_$outcome", modify

*column name
 putexcel E1=("Synth 2") E2=("Predictor") F2=("Treated") G2=("Synthetic")  E40=("RMSPE")   ///
 
*predictor balance
 matrix list e(X_balance)
 putexcel E3=matrix(e(X_balance)), rownames
 *RMSPE
 matrix list e(RMSPE)
 putexcel E41=matrix(e(RMSPE))

}

else if "_$donor" == "_donors_drop2"{

*set
putexcel set "post_synth/weight_balance/post_synth_balance_RR_$outcome", modify

*column name
 putexcel H1=("Synth 3") H2=("Predictor") I2=("Treated") J2=("Synthetic")  H40=("RMSPE")   ///
 
*predictor balance
 matrix list e(X_balance)
 putexcel H3=matrix(e(X_balance)), rownames
 *RMSPE
 matrix list e(RMSPE)
 putexcel H41=matrix(e(RMSPE))

 }

 ////////////
**V matrix
////////////


if "_$donor" == "_donors_all"{

*set
putexcel set "post_synth/weight_balance/post_synth_Vmat_RR_$outcome", replace

*column name
 putexcel B1=("V matrix, synth 1") 	
 
 *V matrix
 matrix list e(V_matrix)
 putexcel B2=matrix(e(V_matrix)), rownames 
}


if "_$donor" == "_donors_drop1"{

*set
putexcel set "post_synth/weight_balance/post_synth_Vmat_RR_$outcome", modify

 putexcel B40=("V matrix, synth 2") 	

 *V matrix
 matrix list e(V_matrix)
 putexcel B41=matrix(e(V_matrix)), rownames 
}

if "_$donor" == "_donors_drop2"{

*set
putexcel set "post_synth/weight_balance/post_synth_Vmat_RR_$outcome", modify

 putexcel B80=("V matrix, synth 3") 	

 *V matrix
 matrix list e(V_matrix)
 putexcel B81=matrix(e(V_matrix)), rownames 
}
