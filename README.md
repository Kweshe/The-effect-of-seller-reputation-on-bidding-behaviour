# The-effect-of-seller-reputation-on-bidding-behaviour
The study analyzed eBay UK car auction data to examine how seller reputation affects auction outcomes. Using quantile regression, it found that sellers with exclusively positive feedback achieve higher prices, not because they attract more bidders, but because bidders adopt more aggressive bidding strategies.

## Abstract
This study, using data from the UK eBay car auction market, examined the
relationship between seller reputation and auction outcomes. U sing the robust
analytical tool of quartile regression the study found that sellers with exclusively
positive feedback tend to sell their products at higher prices compared to those
with tarnished reputations. Further more u sing a negative binomial, the research
shows t hat this price difference is not due to attracting more bidders as the results
suggest that seller reputation doesn't influenc e the number of bidders. However,
when competing for item market e d by a s eller with good reputations , bidders use
a more aggressive bidding strategy, resulting in higher bid increments. This
suggests that the price premium associated with good seller reputations is linked
to a more competitive bidding approach, even though the number of bidders
remains relatively constant.

## Research Questions

Main Research Question:
How does seller reputation influence auction outcomes in the eBay car market?

Sub-questions:
1. Does the winning bid decrease when a seller has one or more negative ratings?
2. Does seller reputation influence the number of bidders in an eBay auction?
3. Is bid increment the mechanism through which seller reputation affects the winning bid?

## Methodology
The methodological approach taken is a juxtaposition of two econometric models in order to address the different research questions. A quantile regression is us ed to
test the first and the third question whilst the second is explored through a negative
binomial.


## Data
The data was collected through web scraping, using a Python scraper with BeautifulSoup to extract product links and Octoparse to gather technical characteristics, auction details, and seller ratings. The dataset covers UK used-car auctions that ended between 17 July and 17 August 2023. During data cleaning, listings marked “spare or repair,” prematurely terminated auctions, commercial vehicles, cars manufactured before 1990, and body types outside Hatchback, Coupe, Saloon, Convertible, Estate, and SUV were excluded. Only the top 15 car brands (≥100 observations each) were retained to reduce heterogeneity and facilitate regression analysis. Finally, items priced below £300 (mostly car parts) were removed.




