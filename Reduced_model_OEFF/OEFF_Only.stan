
data{
  int n_grid;
  vector[n_grid] deltaOEFF_grid;
  int<lower = 0> N; 
  int<lower = 0, upper = 1> y[N]; 
  vector[N] deltaOEFF; 
}
parameters{
  real beta; // slopes (on standardized scale)
}

model{
  beta ~ normal(0.92, 0.05);
  for(i in 1:N){
    y[i] ~ bernoulli_logit(deltaOEFF[i] * beta);
  }
}
generated quantities{
  vector<lower = 0, upper = 1>[n_grid] prob_grid;
  for(i in 1:n_grid){
    prob_grid[i] = inv_logit(deltaOEFF_grid[i] * beta);
  }
  
}




