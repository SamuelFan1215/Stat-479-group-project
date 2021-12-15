data{
  int n_grid;
  vector[n_grid] deltaDEFF_grid;
  int<lower = 0> N; 
  int<lower = 0, upper = 1> y[N]; 
  vector[N] deltaDEFF; 
}
parameters{
  real beta; // slopes (on standardized scale)
}

model{
  beta ~ normal(-0.3, 0.05);
  for(i in 1:N){
    y[i] ~ bernoulli_logit(deltaDEFF[i] * beta);
  }
}
generated quantities{
  vector<lower = 0, upper = 1>[n_grid] prob_grid;
  for(i in 1:n_grid){
    prob_grid[i] = inv_logit(deltaDEFF_grid[i] * beta);
  }
  
}




