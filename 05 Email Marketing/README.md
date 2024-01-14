# Spotlight Gazette Newsletter
  
💡 Send personalized customer emails based off marketing analytics for a Streaming Company such as Netflix, to recommend their users new content to watch based on their behavior and past visualizations on the platform.

### Key Business Requirements:

1. Identify top 2 categories for each customer based off their past rental history
2. For each customer recommend up to 3 popular unwatched films for each category
3. Generate 1st category insights that includes:
    - How many total films have they watched in their top category?
    - How many more films has the customer watched compared to the average DVD Rental Co customer?
    - How does the customer rank in terms of the top X% compared to all other customers in this film category?
4. Generate 2nd insights that includes:
    - How many total films has the customer watched in this category?
    - What proportion of each customer’s total films watched does this count make?
5. Identify each customer’s favorite actor and film count, then recommend up to 3 more unwatched films starring the same actor


### Data Points:

**Category Data Points**

1. Top ranking category name: `cat_1`
2. Top ranking category customer insight: `insight_cat_1`
3. Top ranking category film recommendations: `cat_1_reco_1`, `cat_1_reco_2`, `cat_1_reco_3`
4. 2nd ranking category name: `cat_2`
5. 2nd ranking category customer insight: `insight_cat_2`
6. 2nd ranking category film recommendations: `cat_2_reco_1`, `cat_2_reco_2`, `cat_2_reco_3`

**Actor Data Points**

1. Top actor name: `actor`
2. Top actor insight: `insight_actor`
3. Actor film recommendations: `actor_reco_1`, `actor_reco_2`, `actor_reco_3`

**DATA POINTS OUTPUT**

📌 Output Section 1: You’ve watched {`rental_count`} {`category_name`} films, that’s {`average_comparison`} more than the Dvd Rental Co average and puts you in the top {`percentile`}% of {`category_name`} gurus!


📌 Output Section 2: You’ve watched {`rental_count`} {`category_name`} films making up {`category_percentage`}% of your entire viewing history!


📌 Output Section 3: You’ve watched <`rental_count`> films featuring <`actor_name`>! Here are some other films <`first_name`> stars in that might interest you!