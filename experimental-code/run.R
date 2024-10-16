system.time(
  run_estimation(2000, 100, 0)
)

path <- '../data/09242215/'
files <- list.files(path, full.names = T)
df <- data.frame() # columns: id, class, f, q, ar, n
for(f in files){
  f <- readRDS(f)
  f[[]]
}
