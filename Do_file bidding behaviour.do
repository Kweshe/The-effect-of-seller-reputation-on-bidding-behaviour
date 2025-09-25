

clear


import excel "C:\Users\karlo\Documents\Dissertation\Analysis\Final dataset\combine_increment - 20 brands.xlsx", sheet("Sheet1") firstrow


ssc install outreg2

corr  Winning_end Mileage  duration starting_price bidders mean_increment 

by group_starting, sort : summarize Winning_end bid positive12 negative12 Mileage mean_increment bidders Year starting_price

by rating_category, sort : summarize Winning_end bid positive12 negative12 Mileage mean_increment bidders Year starting_price


outreg2 using "C:\Users\karlo\Documents\Dissertation\Analysis\Final dataset\graphs\Table_Stat1.doc", sum(log) 
outreg2 using x.doc, replace sum(log)

******************Cleaning**************
summarize Winning_end bid positive12 negative12 Mileage mean_increment bidders Year starting_price
drop A Unnamed0

drop features MOTExpiry Variant Drive_Side Number_Doors Num_Cylinder Safety_Features emission_class house_power Field5 Field6 Field7 Field8 Field9 Field10 Field11 Field12 Field13 Field14 Field15 Field16 Field17 Field18 Field19 Field20 Field21 Field22 Field23 Field24 Field25 Field26 Field27 Field28 Field29 Field30 Field31 Field32 Field33 Field34 Field35 Field36 Field37 Field38 Field39 Field40 Field41 Field42 Text_y Field44 Field45 Field46 Field47 Field48 Field49_y Field50_y Field51 Field52 Field53 Field54 Field55 Field56 Field57 Field58 Field59 Field60 Field61 Field62 Field63 Field64 Field65 Field66 Field67 Field68 Field69 Field70 Field71 Field72 Field73 Field74 Field75 Field76 Field77 Field78 Field79 Field80 Field81 Field82 Field83 Field84 Field85 Field86 Field87  Field88 Field89 Field90 Field91 Field92 Field93 Field94 Field95 Field96 Field97 Field98 Field99 Field100 Field101 Field102 Field103 Field104 Field105 Field107 Field108 Field109a Field109 starting Date1 V5C

drop if Winning_end < 300
drop if Year == .
drop if Mileage == .
drop if Transmission2 == .
drop if BodyType2 == .
drop if typeof_fuel2 == .
drop if Manucfaturer2 == .
drop if duration == .
drop if warranty == .
drop if rating_category== .


replace  Manufacturer = "NISSAN" if  Manufacturer == "Nissan"
replace  Manufacturer = "NISSAN" if  Manufacturer == "nissan"
replace  Manufacturer = "BMW" if  Manufacturer == "bmw"
replace  Manufacturer = "Audi" if  Manufacturer == "audi"
replace  Manufacturer = "Ford" if  Manufacturer == "FORD"

replace  Manufacturer = "Peugeot" if  Manufacturer == "peugeot"
replace  Manufacturer = "Volvo" if  Manufacturer == "VOLVO"

************Transformation*****************


encode BodyType, gen(BodyType2)
encode typeof_fuel, gen(typeof_fuel2)
encode  Manufacturer, gen(Manucfaturer2)
encode  Transmission, gen(Transmission2)
encode  type_seller, gen(type_seller2)
encode duration, gen(duration2)

*********************

gen group_starting = 1 if starting_price >= 1000
replace group_starting=0 if starting_price < 1000


gen warranty = 1 if return == "Returns accepted"
replace warranty =0 if missing(return )

replace starting_price = Winning_end if bid < 1




***Descriptive statistics**********
by rating_category, sort : summarize Winning_end if bid > 0

sum Winning_end if bid > 0, detail

quantile Winning_end if bid >0, recast(area) rlopts(lcolor(ltbluishgray%71))

by rating_category, sort : summarize mean_increment if bid > 1
summarize mean_increment if bid > 1

by rating_category, sort : summarize seller_score



************Transform Mileage*****
gen logmileage = log(Mileage)
gen Mileage2 = real(Mileage)
gen Year2 = real(Year)

gen lopprice = log(Winning_end)
**gen startingprice = real(starting_price)

gen logpos = log(positive12 + 1)
*replace logpos = 0 if positive12 <= 0

drop logneg 

gen logneg = log(negative12 + 1) 
*replace logneg = 0 if negative12 <= 0


gen Neg = 1 if negative12 > 0
replace Neg = 0 if negative12 == 0


gen rating2 = 1 if pourcentage == 100
replace rating2 = 1 if pourcentage == 0
replace rating2 = 0 if pourcentage > 0 & pourcentage < 100


gen type_seller = "Dealer" if type_of_seller == "Dealer"
replace type_seller = "Private Seller" if type_of_seller == "Private Seller"
replace type_seller = "Not specified" if missing(type_of_seller )


gen logscrore = log(seller_score + 1)

summarize Winning_end bid  positive12 negative12 Mileage mean_increment bidders
tab warranty

**********************Linear regression ***********************

areg Winning_end ib1.rating_category warranty logmileage Year weekend i.duration bidders i.Transmission2 i.typeof_fuel2 i.BodyType2 if bid> 1 , a(Manucfaturer2) , robust

reg Winning_end ib1.rating_category warranty logmileage Year weekend i.duration bidders i.Transmission2 i.typeof_fuel2 i.BodyType2 i.Manucfaturer2 i.type_seller2 if bid> 1 & Winning_end > 300, c(seller_name)

reg Winning_end ib1.rating_category warranty logmileage Year weekend i.duration bidders i.Transmission2 i.typeof_fuel2 i.BodyType2 i.Manucfaturer2 i.type_seller2 if bid> 1 & Winning_end > 300

gen net

rvfplot 
hettest, fstat
ssc install qreg2


*************Normality test********
sfrancia Winning_end

******************** quantile regression**************************
**************XXX*********************************************************************************
*******************************************************************************************************************
bsqreg Winning_end ib1.rating_category warranty logmileage Year weekend i.duration bidders i.Transmission2 i.typeof_fuel2 i.BodyType2 i.Manucfaturer2 if bid> 1 & Winning_end > 300, quantile(.25)
outreg2 using "C:\Users\karlo\Documents\Dissertation\Analysis\Final dataset\graphs\Table_regQuantile1.rtf", ctitle("Quantile regression (0.25)")

outreg2 using "C:\Users\karlo\Documents\Dissertation\Analysis\Final dataset\graphs\Table_regQuantile22.rtf", ctitle("Quantile (0.25)") keep(0.rating_category 2.rating_category 1.duration 3.duration 5.duration 7.duration 10.duration logmileage Year bidders warranty starting_price)

bsqreg Winning_end ib1.rating_category warranty logmileage Year weekend i.duration bidders i.Transmission2 i.typeof_fuel2 i.BodyType2 i.Manucfaturer2 if bid> 1 & Winning_end > 300, quantile(.5)
outreg2 using "C:\Users\karlo\Documents\Dissertation\Analysis\Final dataset\graphs\Table_regQuantile1.rtf", ctitle("Quantile regression (0.5)") append
outreg2 using "C:\Users\karlo\Documents\Dissertation\Analysis\Final dataset\graphs\Table_regQuantile22.rtf", ctitle("Quantile (0.5)") append keep(0.rating_category 2.rating_category 1.duration 3.duration 5.duration 7.duration 10.duration logmileage Year bidders warranty starting_price)

margins rating_category
marginsplot

bsqreg Winning_end ib1.rating_category warranty logmileage Year weekend i.duration bidders i.Transmission2 i.typeof_fuel2 i.BodyType2 i.Manucfaturer2 if bid> 1 & Winning_end > 300, quantile(.75)
outreg2 using "C:\Users\karlo\Documents\Dissertation\Analysis\Final dataset\graphs\Table_regQuantile1.rtf", ctitle("Quantile regression (0.75)") append

outreg2 using "C:\Users\karlo\Documents\Dissertation\Analysis\Final dataset\graphs\Table_regQuantile22.rtf", ctitle("Quantile (0.75)") append keep(0.rating_category 2.rating_category 1.duration 3.duration 5.duration 7.duration 10.duration logmileage Year bidders warranty starting_price)

margins rating_category
marginsplot

sqreg Winning_end ib1.rating_category warranty logmileage Year weekend i.duration bidders i.Transmission2 i.typeof_fuel2 i.BodyType2 i.Manucfaturer2 if bid> 1 & Winning_end > 300, quantile(.25 .5 .75)

bsqreg Winning_end rating_category##warranty logmileage Year weekend i.duration bidders i.Transmission2 i.typeof_fuel2 i.BodyType2 i.Manucfaturer2 if bid> 1 & Winning_end > 300, quantile(.75)
*****************************************************Exclude if negative ratings received during the last 30 days**************************************************************************
bsqreg Winning_end ib1.rating_category warranty logmileage Year weekend i.duration bidders i.Transmission2 i.typeof_fuel2 i.BodyType2 i.Manucfaturer2 if bid> 1 & Winning_end > 300 & negative1 <1, quantile(.75)
outreg2 using "C:\Users\karlo\Documents\Dissertation\Analysis\Final dataset\graphs\Table_regQuantile1.rtf", ctitle("QR(0.75) if 0 negative rating last month") append
outreg2 using "C:\Users\karlo\Documents\Dissertation\Analysis\Final dataset\graphs\Table_regQuantile22.rtf", ctitle("QR (0.75) if 0 negative rating last month") append keep(0.rating_category 2.rating_category 1.duration 3.duration 5.duration 7.duration 10.duration logmileage Year bidders warranty starting_price)


bsqreg Winning_end ib1.rating_category warranty logmileage Year weekend i.duration bidders i.Transmission2 i.typeof_fuel2 i.BodyType2 i.Manucfaturer2 if bid> 1 & Winning_end > 300 & negative1 <1, quantile(.5)
outreg2 using "C:\Users\karlo\Documents\Dissertation\Analysis\Final dataset\graphs\Table_regQuantile1.rtf", ctitle("QR(0.5) if 0 negative rating last month") append
outreg2 using "C:\Users\karlo\Documents\Dissertation\Analysis\Final dataset\graphs\Table_regQuantile22.rtf", ctitle("QR (0.5) if 0 negative rating last month") append keep(0.rating_category 2.rating_category 1.duration 3.duration 5.duration 7.duration 10.duration logmileage Year bidders warranty starting_price)


*******************************With two rating categories instead of three************************************************

bsqreg Winning_end rating2 warranty logmileage Year weekend i.duration bidders i.Transmission2 i.typeof_fuel2 i.BodyType2 i.Manucfaturer2 if bid> 1 & Winning_end > 300, quantile(.25)

bsqreg Winning_end rating2 warranty logmileage Year weekend i.duration bidders i.Transmission2 i.typeof_fuel2 i.BodyType2 i.Manucfaturer2 if bid> 1 & Winning_end > 300, quantile(.5)
outreg2 using "C:\Users\karlo\Documents\Dissertation\Analysis\Final dataset\graphs\Table_RQ2GROUPS.rtf", ctitle("QR(0.5) with two groups") append
bsqreg Winning_end rating2 warranty logmileage Year weekend i.duration bidders i.Transmission2 i.typeof_fuel2 i.BodyType2 i.Manucfaturer2 if bid> 1 & Winning_end > 300, quantile(.75)
outreg2 using "C:\Users\karlo\Documents\Dissertation\Analysis\Final dataset\graphs\Table_RQ2GROUPS.rtf", ctitle("QR(0.75) with two groups") append
*********************************************************************************
********************************Increment*****************************************

bsqreg mean_increment ib1.rating_category warranty logmileage Year weekend i.duration bidders i.Transmission2 i.typeof_fuel2 i.BodyType2 i.Manucfaturer2 starting_price if bid> 1 & Winning_end > 300, quantile(.25)
outreg2 using "C:\Users\karlo\Documents\Dissertation\Analysis\Final dataset\graphs\Table_regQuantile2.rtf", ctitle("Quantile (0.25)")

outreg2 using "C:\Users\karlo\Documents\Dissertation\Analysis\Final dataset\graphs\Table_regQuantile23.rtf", ctitle("Quantile (0.25)") keep(0.rating_category 2.rating_category 1.duration 3.duration 5.duration 7.duration 10.duration logmileage Year bidders warranty starting_price)


bsqreg mean_increment ib1.rating_category warranty logmileage Year weekend i.duration bidders i.Transmission2 i.typeof_fuel2 i.BodyType2 i.Manucfaturer2 starting_price if bid> 1 & Winning_end > 300, quantile(.5)
outreg2 using "C:\Users\karlo\Documents\Dissertation\Analysis\Final dataset\graphs\Table_regQuantile2.rtf", ctitle("Quantile (0.5)")

outreg2 using "C:\Users\karlo\Documents\Dissertation\Analysis\Final dataset\graphs\Table_regQuantile23.rtf", ctitle("Quantile (0.5)") keep(0.rating_category 2.rating_category 1.duration 3.duration 5.duration 7.duration 10.duration logmileage Year bidders warranty starting_price)


bsqreg mean_increment ib1.rating_category warranty logmileage Year weekend i.duration bidders i.Transmission2 i.typeof_fuel2 i.BodyType2 i.Manucfaturer2 starting_price if bid> 1 & Winning_end > 300, quantile(.75)
outreg2 using "C:\Users\karlo\Documents\Dissertation\Analysis\Final dataset\graphs\Table_regQuantile2.rtf", ctitle("Quantile (0.75)") appen


outreg2 using "C:\Users\karlo\Documents\Dissertation\Analysis\Final dataset\graphs\Table_regQuantile23.rtf", ctitle("Quantile (0.75)") appen keep(0.rating_category 2.rating_category 1.duration 3.duration 5.duration 7.duration 10.duration logmileage Year bidders warranty starting_price)


**************************************************************************
*************************************************************************


sqreg Winning_end i.rating_category warranty logmileage Year weekend i.duration bidders i.Transmission2 i.typeof_fuel2 i.BodyType2 i.Manucfaturer2 if bid> 1 & Winning_end > 300, quantile(.75)
outreg2 using "C:\Users\karlo\Documents\Dissertation\Analysis\Final dataset\graphs\Table_regQuantile1.rtf", ctitle("Quantile regression (0.75)") append

outreg2 using "C:\Users\karlo\Documents\Dissertation\Analysis\Final dataset\graphs\Table_regQuantile22.rtf", ctitle("Quantile (0.75)") append keep(1.rating_category 2.rating_category 1.duration 2.duration 3.duration 4.duration 5.duration logmileage Year bidders warranty)



***********************************Number of bidders ******************************

nbreg bidders ib1.rating_category warranty logmileage Year weekend i.duration i.Manucfaturer2 i.typeof_fuel2 i.Transmission2 i.BodyType2 starting_price if Winning_end > 300

outreg2 using "C:\Users\karlo\Documents\Dissertation\Analysis\Final dataset\graphs\Table_regNB.rtf", ctitle("Negative binomial")
outreg2 using "C:\Users\karlo\Documents\Dissertation\Analysis\Final dataset\graphs\Table_regBN2.rtf", ctitle("effect of reputation on number of bidders") keep(0_rating_category 2.rating_category starting_price 1.duration 3.duration 5.duration 7.duration 10.duration logmileage Year warranty)

nbreg, irr
outreg2 using "C:\Users\karlo\Documents\Dissertation\Analysis\Final dataset\graphs\Table_regNBIRR.rtf", ctitle("Incidence rate ratio")
dataset\graphs\Table_regNegBinomial.rtf", ctitle("IRR") append
outreg2 using "C:\Users\karlo\Documents\Dissertation\Analysis\Final 
margins rating_category

marginsplot

margins, dydx(*) atmeans

outreg2 using "C:\Users\karlo\Documents\Dissertation\Analysis\Final dataset\graphs\Table_ME.rtf", ctitle("Count model: marginal effects") dec(3) keep(0_rating_category 2.rating_category starting_price 1.duration 3.duration 5.duration 7.duration 10.duration logmileage Year warranty starting_price) 

outreg2 using "C:\Users\karlo\Documents\Dissertation\Analysis\Final dataset\graphs\marginal.doc", word replace ctitle(Marginal Effects)


nbreg bidders ib1.rating_category warranty logmileage Year weekend i.duration i.Manucfaturer2 i.typeof_fuel2 i.Transmission2 i.BodyType2 if Winning_end > 300

outreg2 using "C:\Users\karlo\Documents\Dissertation\Analysis\Final dataset\graphs\Table_regNegBinomial.rtf", ctitle("Negative binomial") append
outreg2 using "C:\Users\karlo\Documents\Dissertation\Analysis\Final dataset\graphs\Table_regBinN2.rtf", ctitle("effect of reputation on number of bidders") append keep(0.rating_category 2.rating_category starting_price 1.duration 3.duration 5.duration 7.duration 10.duration logmileage Year warranty)

margins, dydx(*) atmeans

marginsplot

nbreg bidders ib1.rating_category warranty logmileage Year weekend i.duration i.Manucfaturer2 i.typeof_fuel2 i.Transmission2 i.BodyType2 if Winning_end > 300

outreg2 using "C:\Users\karlo\Documents\Dissertation\Analysis\Final dataset\graphs\Table_regNB.rtf", ctitle("Negative binomial")
outreg2 using "C:\Users\karlo\Documents\Dissertation\Analysis\Final dataset\graphs\Table_regBN2.rtf", ctitle("effect of reputation on number of bidders") append keep(0_rating_category 2.rating_category starting_price 1.duration 3.duration 5.duration 7.duration 10.duration logmileage Year warranty)





Validation test: Likelihood ratio test 

poisson bidders ib1.rating_category warranty logmileage Year weekend i.duration i.Manucfaturer2 i.typeof_fuel2 i.Transmission2 i.BodyType2 if Winning_end > 300
estimates store m1
outreg2 using "C:\Users\karlo\Documents\Dissertation\Analysis\Final dataset\graphs\Table_regPoisson.rtf", ctitle("Poisson")

nbreg bidders ib1.rating_category warranty logmileage Year weekend i.duration i.Manucfaturer2 i.typeof_fuel2 i.Transmission2 i.BodyType2 if Winning_end > 300
estimates store m2

lrtest m1 m2, force



**drop outliers


 positive12 Winning_end)
twoway (scatter negative12 Winning_end)

twoway (scatter Winning_end MileageS)



************************** Negative binomial****************************************


histogram bidders, discrete freq title(Distribution of number of bidders) color(eltblue) saving(C:\Users\karlo\Documents\Dissertation\Analysis\Final dataset\graphs\Histogram of biddersV2)
tabstat bidders, by(rating_category) stats(mean v n)

histogram Winning_end , discrete freq 
********************************************************************************************

tabulate bidders


tabstat bidders, by(rating_category) stats(mean v n)




******************test pour graph******************


twoway (hist Winning_end if duration==7, percent bin(180) barwidth(0.01) color(ltblue) xtitle("XXXXX")) (hist Winning_end if duration==10, percent bin(180) barwidth(0.01) color(gs13) xline(1440000)), title(Distribution of winning bid) legend(order(1 "7 days" 2 "10 days"))

twoway (hist Winning_end if duration==7, percent bin(180) barwidth(0.01) color(ltblue) xtitle("XXXXX")) (hist Winning_end if duration==10, percent bin(180) barwidth(0.01) color(gs13) xline(1440000)), title(Distribution of winning bid) legend(order(1 "7 days" 2 "10 days"))

hist mean_increment, percent bin(180) barwidth(0.01) color(ltblue) 
mean Winning_end
