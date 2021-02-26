nogo_qs = 8
go_qs = 32

qs = c(rep('Go', go_qs), rep('NoGo', nogo_qs))
num_qs = length(qs)
qs = sample(qs, num_qs)
