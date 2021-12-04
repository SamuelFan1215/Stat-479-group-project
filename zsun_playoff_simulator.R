# Zhongxuan: This script is a function for the simulation of the NBA playoff (default year 2019)

# round 1: 16 teams play each other
# round 2: 8 teams play each other (conference semifinals)
# round 3: 4 teams play each other (conference finals)
# round 4: 2 teams fight for CHIAMPIONSHHHHHIIIIIP (NBA final)


##### function to simulate binomial(p,n) [this function will be used in the next function]
### Input Variables:
# team_name1: name of the team 1 [city]
# team_name2: name of the team 2 [city]
# P: probability matrix containing the pairwise probability of winning a game

battle <- function(team_name1, team_name2, P){
  t1.idx <- which(rownames(P) == team_name1)
  t2.idx <- which(rownames(P) == team_name2)
  p.win <- P[t1.idx,t2.idx] # probability of team1 beats team2
  simu_result <- rbinom(n=1,size=7,prob=p.win)
  if(simu_result >= 4){
    return(team_name1)
  } else{
    return(team_name2)
  }
}


##### Function to simulate result of 1 conference, team1 vs team2; team3 vs team4; winner1 vs winner2 ...
### Input Variables:
# team_list
### Variables in function:
# g1.*: round 1 game winners
# g2.*: conference semifinals game winners
# g3.*: conference finals game winners
# final: champion
# second_place: 2nd place
team_list_2019 <- c("Golden State","LA Clippers","Houston","Utah","Portland","Oklahoma City","Denver","San Antonio","Milwaukee","Detroit","Boston","Indiana","Philadelphia","Brooklyn","Toronto","Orlando")
simu_final <- function(team_name_list = team_list_2019,P){
  #
  g1.1 <- battle(team_name_list[1],team_name_list[2],P)
  g1.2 <- battle(team_name_list[3],team_name_list[4],P)
  g2.1 <- battle(g1.1,g1.2,P) # 1 of the 4
  #
  g1.3 <- battle(team_name_list[5],team_name_list[6],P)
  g1.4 <- battle(team_name_list[7],team_name_list[8],P)
  g2.2 <- battle(g1.3,g1.4,P) # 1 of the 4
  #
  g3.1 <- battle(g2.1,g2.2,P) # 1 of the 8 (semi final)
  ##
  g1.5 <- battle(team_name_list[9],team_name_list[10],P)
  g1.6 <- battle(team_name_list[11],team_name_list[12],P)
  g2.3 <- battle(g1.5,g1.6,P) # 1 of the 4
  #
  g1.7 <- battle(team_name_list[13],team_name_list[14],P)
  g1.8 <- battle(team_name_list[15],team_name_list[16],P)
  g2.4 <- battle(g1.7,g1.8,P) # 1 of the 4
  #
  g3.2 <- battle(g2.3,g2.4,P) # 1 of the 8 (semi final)
  ####
  final <- battle(g3.1,g3.2,P) # NBA FINAL
  second_place <- ifelse(g3.1==final,g3.2,g3.1)
  
  return(c(final,second_place))
}

print("You can use function 'simu_final(team_name_list = team_list_2019,P)' to simulate one round of playoff")
print("The order of the team name is important!! Please use the default option for simulation of 2019 playoff")

