data {
  int K; // K = 1
  int D; // number of predictors
  int<lower = 0> N; // number of observed data
  int<lower = 0, upper = 1> y[N]; // response variable
  matrix[N, D] x; // matrix of predictors
  int n_grid; // number of points in the grid of x values at which we want to evaluate P(y = 1|x)
  vector[n_grid] deltaOEFF_grid; // two grids for generated quantities, length = 181
  vector[n_grid] deltaDEFF_grid; 
}
parameters {
  matrix[D, K] beta; // coefficient matrix
}
model {
  matrix[N, K] x_beta = x * beta;

  to_vector(beta)[1] ~ normal(0.75, 0.05); // prior for beta_1, not specified
  to_vector(beta)[2] ~ normal(-0.39, 0.05); // prior for beta_2
    for(n in 1:N) {
    y[n] ~ bernoulli_logit(x_beta[n]'); // use inverse matrix
  }
}

generated quantities{
  vector<lower = 0, upper = 1>[n_grid] prob_grid; // predictive probabilities grid
  
  vector<lower = 0, upper = 1>[n_grid] prob_meanD; // fix deltaDEFF at mean
  vector<lower = 0, upper = 1>[n_grid] prob_meanD_minus_sd; // fix deltaDEFF at mean-sd
  vector<lower = 0, upper = 1>[n_grid] prob_meanD_plus_sd; // fix deltaDEFF at mean+sd
  
  vector<lower = 0, upper = 1>[n_grid] prob_meanO; 
  vector<lower = 0, upper = 1>[n_grid] prob_meanO_minus_sd; 
  vector<lower = 0, upper = 1>[n_grid] prob_meanO_plus_sd; 
  
  for(p in 1:n_grid){
    prob_grid[p] = inv_logit(deltaOEFF_grid[p] * to_vector(beta)[1] + deltaDEFF_grid[p] * to_vector(beta)[2]); // posterior predivtive probabilities
  }
  // with changing deltaDEFF
  for(i in 1:n_grid){
    prob_meanD[i] = inv_logit(deltaOEFF_grid[i] * to_vector(beta)[1] + mean(x[,2]) * to_vector(beta)[2]);
  }
  for(j in 1:n_grid){
    prob_meanD_minus_sd[j] = inv_logit(deltaOEFF_grid[j] * to_vector(beta)[1] + (mean(x[,2]) - sd(x[,2])) * to_vector(beta)[2]);
  }
  for(k in 1:n_grid){
    prob_meanD_plus_sd[k] = inv_logit(deltaOEFF_grid[k] * to_vector(beta)[1] + (mean(x[,2]) + sd(x[,2])) * to_vector(beta)[2]);
  }
  // with changing deltaOEFF
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





