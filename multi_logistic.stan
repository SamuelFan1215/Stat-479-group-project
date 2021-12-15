// The stan file creates a logistci regression with y = X times beta
// Vectors in section generated quantities are for posterior prediction
data {
  int K; // number of column for beta
  int D; // number of predictors
  int<lower = 0> N; // number of observed data
  int<lower = 0, upper = 1> y[N]; // response variable
  matrix[N, D] x; // matrix of predictors
  int n_grid; // length of posterior predictiom grid
  vector[n_grid] deltaOEFF_grid; // two grids for generated quantities
  vector[n_grid] deltaDEFF_grid; // grid for predictor 1
}
parameters {
  matrix[D, K] beta; // coefficient matrix
}
model {
  matrix[N, K] x_beta = x * beta; 

  to_vector(beta)[1] ~ normal(0.75, 0.05); // prior for beta_1
  to_vector(beta)[2] ~ normal(-0.39, 0.05); // prior for beta_2
    for(n in 1:N) {
    y[n] ~ bernoulli_logit(x_beta[n]'); // use inverse matrix
  }
}

generated quantities{
  // plot 1
  vector<lower = 0, upper = 1>[n_grid] prob_meanD; // fix deltaDEFF at mean
  vector<lower = 0, upper = 1>[n_grid] prob_meanD_minus_sd; // fix deltaDEFF at mean - 1sd
  vector<lower = 0, upper = 1>[n_grid] prob_meanD_plus_sd; // fix deltaDEFF at mean + 1sd
  // plot 2
  vector<lower = 0, upper = 1>[n_grid] prob_meanO; // fix deltaOEFF at mean
  vector<lower = 0, upper = 1>[n_grid] prob_meanO_minus_sd; // fix deltaOEFF at mean - 1sd
  vector<lower = 0, upper = 1>[n_grid] prob_meanO_plus_sd; // fix deltaOEFF at mean + 1sd

  // deltaOEFF on x-axis and fix deltaDEFF
  for(i in 1:n_grid){
    prob_meanD[i] = inv_logit(deltaOEFF_grid[i] * to_vector(beta)[1] + mean(x[,2]) * to_vector(beta)[2]);
  }
  for(j in 1:n_grid){
    prob_meanD_minus_sd[j] = inv_logit(deltaOEFF_grid[j] * to_vector(beta)[1] + (mean(x[,2]) - sd(x[,2])) * to_vector(beta)[2]);
  }
  for(k in 1:n_grid){
    prob_meanD_plus_sd[k] = inv_logit(deltaOEFF_grid[k] * to_vector(beta)[1] + (mean(x[,2]) + sd(x[,2])) * to_vector(beta)[2]);
  }
  // deltaDEFF on x-axis and fix deltaOEFF
  for(a in 1:n_grid){
    prob_meanO[a] = inv_logit(mean(x[,1]) * to_vector(beta)[1] + deltaDEFF_grid[a] * to_vector(beta)[2]);
  }
  for(b in 1:n_grid){
    prob_meanO_minus_sd[b] = inv_logit((mean(x[,1]) - sd(x[,1])) * to_vector(beta)[1] + deltaDEFF_grid[b] * to_vector(beta)[2]);
  }
  for(c in 1:n_grid){
    prob_meanO_plus_sd[c] = inv_logit((mean(x[,1]) + sd(x[,1])) * to_vector(beta)[1] + deltaDEFF_grid[c] * to_vector(beta)[2]);
  }
}





