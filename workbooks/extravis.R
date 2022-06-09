library(tidyverse)
library(vip)
library(tidymodels)
library(cowplot)

load("final.RData")

plot <- boost_fit %>%
  vip(num_features = 20) +
  theme_cons

ggsave("importance.png", plot)

lasso <- ggdraw() + draw_image("images/lassoimp.png")

rand <- ggdraw() + draw_image("images/randimp.png")

xg <- ggdraw() + draw_image("images/xgimp.png")

grid <- plot_grid(lasso, rand, xg, ncol = 1)

ggsave("gridimp.png", grid)
