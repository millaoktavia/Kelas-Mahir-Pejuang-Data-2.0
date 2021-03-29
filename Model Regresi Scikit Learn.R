---
  title: "Model Regresi Scikit Learn di R"
author: "Milla Oktavia"
date: "3/29/2021"
output:
html_document: default
pdf_document: default
---
  
  ```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

![](D:/Milik milla/PSDS/Kelas Mahir/Header KM0301.png)

### **Import Library**
```{r}
library(heatmaply) #Untuk plot heatmap Missing Data
library(visdat) #Untuk plot Missing Data
library(reshape2) #Modifikasi DataFrame
library(tidyr) #Modifikasi DataFrame
library(ggplot2) #Plot
library(psych) #Pair Plot
library(DataExplorer) #Corelation Plot
```

## **Apa sih itu Regresi?**
Apa sih itu Regresi?
Regresi adalah ukuran hubungan antara nilai rata-rata dari satu variabel (misalnya keluaran) dan nilai yang sesuai dari variabel lain (misalnya waktu dan biaya).
Model regresi adalah model yang menghasilkan nilai regresi.Data yang digunakan untuk model regresi adalah data kontinu
Apa sih Machine Learning?
Machine learning adalah aplikasi dari disiplin ilmu kecerdasan buatan (Artificial Intelligence) yang menggunakan teknik statistika untuk menghasilkan suatu model otomatis dari sekumpulan data, dengan tujuan memberikan komputer kemampuan untuk "belajar".
Machine Learning Regresi
![](D:/Milik milla/PSDS/Kelas Mahir/LossSideBySide.png)
Tujuan kita adalah menghasilkan garis regresi yang mendekati pola titik-titik data yang sesungguhnya dengan kesalahan sekecil mungkin.
Dua tipe Machine Learning Regresi Secara Umum 
1.Model Regresi Statistik, seperti Linear, Non-Linear, Ridge, Lasso, dll
2.Model Regresi dengan Jaringan Syaraf Tiruan (Di Bahas Nanti Yaa)

### **Contoh Data Dua Variabel**
### **Mengakses Dataset**

```{r}
df  <- read.csv("https://raw.githubusercontent.com/millaoktavia/Kelas-Mahir-Pejuang-Data-2.0/main/datacontoh.csv",                stringsAsFactors = T)
head(df)
```
### **Melihat statistik data**
```{r}
summary(df)
```
###**Scatter Plot Data**
```{r}
g=ggplot(df,aes(Total.Salary,Total.Compensation))+geom_point()+
    labs(title = "Gaji VS Kompensasi",
        x = "Gaji",
        y = "Kompensasi")
g
```
```{r}
#Membuat garis regresi
g1=ggplot(df,aes(Total.Salary,Total.Compensation))+geom_point()+geom_smooth(method="lm",se=T)+
    labs(title = "Gaji VS Kompensasi",
        x = "Gaji",
        y = "Kompensasi")
g1
```
Di atas terlihat dari grafik Gaji VS Kompensasi dilakukan prediksi nilai menggunakan regresi linear. Garis biru adalah hasil prediksi dari regresi linear

##**Real Project Model Regresi**
### **Import Library**
```{r}
library(heatmaply) #Untuk plot heatmap Missing Data
library(visdat) #Untuk plot Missing Data
library(reshape2) #Modifikasi DataFrame
library(tidyr) #Modifikasi DataFrame
library(ggplot2) #Plot
library(psych) #Pair Plot
library(DataExplorer) #Corelation Plot
library(tidyverse) #mutate function
```
##**Mengakses Dataset**
```{r}
df_1  <- read.csv("https://raw.githubusercontent.com/millaoktavia/Kelas-Mahir-Pejuang-Data-2.0/main/train.csv",
                stringsAsFactors = T)
head(df_1)
```
##**Eksplorasi Data(Exploration Data Analysis)**
Exploratory Data Analysis mengacu pada proses kritis dalam melakukan investigasi awal pada data untuk menemukan pola, untuk menemukan anomali, untuk menguji hipotesis dan untuk memeriksa asumsi dengan bantuan statistik ringkasan dan representasi grafis. Dengan melakukan EDA, kita dapat lebih memahami kondisi dataset yang kita miliki.
### Dimensi Data
```{r}
dim(df_1)
```
### **Melihat statistik data**
```{r}
summary(df_1)
```

```{r}
#Melihat distribusi kolom target(harga rumah)
p1 <- df_1 %>%
  ggplot(aes(x = SalePrice)) +
  geom_histogram(aes(x = SalePrice, stat(density)),
                 bins = 100,
                 fill = "cornflowerblue",
                 alpha = 0.7) +
  geom_density(color = "midnightblue") +
  scale_x_continuous(breaks= seq(0, 800000, by=100000), labels = scales::comma) +
  labs(x = "Sale Price", y = "", title = "Density of Sale Price") +
  theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1))
p1
```
```{r}
#Melihat inforsimasi kolom dataset
str(df_1)
```

#Melihat nilai korelasi antar variable factor
```{r}
df_1[1:5] %>%
  mutate_if(is.numeric, log) %>%
  plot_correlation()
```

##**Data Cleaning**
Data cleansing atau data cleaning merupakan suatu proses mendeteksi dan memperbaiki (atau menghapus) suatu record yang 'corrupt' atau tidak akurat berdasarkan sebuah record set, tabel, atau database. Agar mempunyai struktur yang lebih baik.
```{r}
##Mengisi missing value

vis_miss (df_1[1:30])    #Melihat Missing Value
```

*Memperbaiki nilai yang hilang pada kolom LotFrontage *
```{r}
df_1$LotFrontage=ifelse(is.na(df_1$LotFrontage),
                        ave(df_1$LotFrontage,FUN=function(x) mean(x,na.rm=TRUE)),
                        df_1$LotFrontage)
```

##**Membangun Model Regresi**
```{r}
model = lm(X~SalePrice, data=df_1)
summary(model)
```

###*Grafik Linear Regresi*
```{r}
g1= plot(df_1$X,df_1$SalePrice,xlab = "X",ylab ="Sale Price",col="blue")
abline(lm(df_1$X~df_1$SalePrice),col="red")
```
##**Melihat variabel utama(paling berpengaruh)**
##**Mengekspor model ke dalam file Pickle**

