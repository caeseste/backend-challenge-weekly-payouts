# Backend coding challenge

Make a system to calculate how much money should be disbursed to each merchant based on the following rules:

- Disbursements are done weekly on Monday.
- We disburse only orders which status is completed.
- The disbursed amount has the following fee per order:
  - 1% fee for amounts smaller than 50 €
  - 0.95% for amounts between 50€ - 300€
  - 0.85% for amounts over 300€


The seed data contains merchants, shoppers and orders.  Their corresponding structure is shown below:


### Merchants
```
ID | NAME                      | EMAIL                             | CIF
1  | Treutel, Schumm and Fadel | info@treutel-schumm-and-fadel.com | B611111111
2  | Windler and Sons          | info@windler-and-sons.com         | B611111112
3  | Mraz and Sons             | info@mraz-and-sons.com            | B611111113
4  | Cummerata LLC             | info@cummerata-llc.com            | B611111114
```

### Shoppers
```
ID | NAME                 | EMAIL                              | NIF
1  | Olive Thompson       | olive.thompson@not_gmail.com       | 411111111Z
2  | Virgen Anderson      | virgen.anderson@not_gmail.com      | 411111112Z
3  | Reagan Auer          | reagan.auer@not_gmail.com          | 411111113Z
4  | Shanelle Satterfield | shanelle.satterfield@not_gmail.com | 411111114Z
```

### Orders
```
ID | MERCHANT ID | SHOPPER ID | AMOUNT | CREATED AT           | COMPLETED AT
1  | 25          | 3351       | 61.74  | 01/01/2017 00:00:00  | 01/07/2017 14:24:01
2  | 13          | 2090       | 293.08 | 01/01/2017 12:00:00  | nil
3  | 18          | 2980       | 373.33 | 01/01/2017 16:00:00  | nil
4  | 10          | 3545       | 60.48  | 01/01/2017 18:00:00  | 01/08/2017 15:51:26
5  | 8           | 1683       | 213.97 | 01/01/2017 19:12:00  | 01/08/2017 14:12:43
```

### Implementation
- All data was imported from the json files. The files were included in repository due to small size of files to make an easer way to reproduce.
- The merchants and shoppers were imported into a single table named users with the following columns:
  - name
  - email
  - rfc (equivalent to CIF for Mexican citizens)
  - user_type (merchant or shopper)
- Due that the merchants and shoppers may have the same id in seeds, it was necessary to change the id to a unique value in table users,
  but the new ids were assigned to the orders table to keep the data integrity.
- The original ids of merchants were keeped in the users table, but the shoppers were assigned with new ones.
- The model User contains the methods to identify the user type and to get their corresponding completed/incompleted orders.
- The model Order contains the necesary methods to calculate the disbursement amount for each order and for a given merchant in a given week.
- To calculate the disbursement amount, it was used BigDecimal to avoid rounding errors.
- Rpec tests were created to the calculation of the disbursement amount.
- The next routes were created to expose the data in the api:

```
GET	/api/v1/users
GET	/api/v1/users/:user_id
GET	/api/v1/users/:user_id/orders
GET	/api/v1/users/:user_id/disbursed?date=[YYYY-MM-DD]
GET	/api/v1/users/:user_id/completed
GET	/api/v1/users/:user_id/incompleted
GET api/v1/orders
```

### Setup development environment
Run next commands in the terminal inside the project folder:

```
$ bundle install
$ docker-compose up -d
$ bin/rails db:create
$ bin/rails db:migrate
$ bin/rails db:seed
$ bin/rails s
```

### Pending tasks
- Create authentication for the api.
- Json hash with details for the response of the call 'disbursed'
- Error handling for the case when the user_id is not valid.