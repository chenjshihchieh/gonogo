#This sets up the variables that you need for the task

#----------------------------------------------#
########Number of Questions#############
#----------------------------------------------#
nogo_qs = 8
go_qs = 32


#----------------------------------------------#
###Scrambled the order of Go NoGo questions#####
#----------------------------------------------#
qs = c(rep('Go', go_qs), rep('NoGo', nogo_qs))
num_qs = length(qs)
qs = sample(qs, num_qs)