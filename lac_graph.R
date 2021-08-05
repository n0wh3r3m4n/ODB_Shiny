if (require("ggrepel")!=TRUE){
  install.packages("ggrepel")
}
if (require("reshape2")!=TRUE){
  install.packages("reshape2")
}
library(ggrepel)
library(reshape2)

my_pal <- function(range = c(1, 6)) {
  force(range)
  function(x) scales::rescale(x, to = range, from = c(0, 1))
}

hist_odb <- read.csv("hist_odb.csv",stringsAsFactors = FALSE)
annos <- unique(hist_odb$Year)
page2 <- hist_odb[!is.na(hist_odb$ISO2)==TRUE & hist_odb$region=="Latin America & Caribbean ",]
plotlist = list()
for (i in 1:length(annos)) {
titulo <- paste0("Barómetro de Datos Abiertos - ",annos[i])
g <- ggplot(data=page2[page2$Year == annos[i],],
       aes(x=Readiness.Scaled,
           y=Implementation.Scaled, label = name)) +
  geom_point(alpha=0.5,color='red',aes(size=Impact.Scaled))+
  continuous_scale(aesthetics=c("size","point.size"),scale_name = "size",
                   palette = my_pal(c(5,30)),limits=c(0,60),
                   breaks=c(10,20,30,40,50),
                   guide = guide_legend(override.aes = list(label = ""))) +
  geom_text_repel(aes(point.size = Impact.Scaled),size = 5)+
  xlim(0,100) + ylim(0,100) +
  labs(title = titulo,
       y = "Implementacion",x="Preparacion",size="Impacto",point.size = "Impacto") +
  theme(plot.title = element_text(size=24,face="bold"),
    axis.text=element_text(size=12),
    axis.title=element_text(size=20,face="bold"),
    legend.text=element_text(size=12),
    legend.title=element_text(size=20,face="bold"),
    plot.margin=unit(c(1,1,1.5,1.2),"cm"))
plotlist[[i]] <- g
}

for (i in 1:length(annos)) {
  nombre <- paste0("LACODB",annos[i],".png")
  png(nombre,width=1200,height=675)
  print(plotlist[[i]])
  dev.off()
}


g <- ggplot(data=page2[page2$Year == 2013 | page2$Year == 2020,],
            aes(x=Readiness.Scaled,
                y=Implementation.Scaled,color=as.character(Year))) +
  geom_point(alpha=0.5,aes(size=Impact.Scaled))+
  continuous_scale(aesthetics=c("size","point.size"),scale_name = "size",
                   palette = my_pal(c(5,30)),limits=c(0,60),
                   breaks=c(10,20,30,40,50)) +
  xlim(0,100) + ylim(0,100) +
  labs(title = "Barómetro de Datos Abiertos - 2013-2020",
       y = "Implementacion",x="Preparacion",size="Impacto",point.size="Impacto",color="Año") +
  theme(plot.title = element_text(size=24,face="bold"),
        axis.text=element_text(size=12),
        axis.title=element_text(size=20,face="bold"),
        legend.text=element_text(size=12),
        legend.title=element_text(size=20,face="bold"),
        plot.margin=unit(c(1,1,1.5,1.2),"cm"))+
  scale_color_manual(values=c("#486c6d","#df6a62")) + 
  guides(color = guide_legend(order = 2), size = guide_legend(order = 1))

png("LACODB2013-2020.png",width=1200,height=675)
print(g)
dev.off()
