from sqlalchemy import create_engine, text, inspect
from datetime import datetime

# Connection credentials
username = "root"
password = "aditya_DB_11%40%23"
host = "localhost"
port = 3306
database = "project"

# SQLAlchemy engine and connection
engine = create_engine(f"mysql+pymysql://{username}:{password}@{host}:{port}/{database}")
connection = engine.connect()
inspector = inspect(engine)

# Utility Functions
def list_tables():
    tables = inspector.get_table_names()
    print("\n📄 Available Tables:")
    for i, table in enumerate(tables, 1):
        print(f"{i}. {table}")
    return tables

def get_columns(table_name):
    return inspector.get_columns(table_name)

def get_primary_keys(table_name):
    return inspector.get_pk_constraint(table_name).get('constrained_columns', [])

def show_existing_address_ids():
    try:
        result = connection.execute(text("SELECT AddressID, Street, City FROM Addresses"))
        rows = result.fetchall()
        print("\n📍 Available Addresses:")
        for row in rows:
            print(dict(row._mapping))
    except Exception as e:
        print(f"❌ Error fetching addresses: {e}")

# Core CRUD
def insert_into_table(table_name):
    try:
        columns = get_columns(table_name)
        insertable = [col for col in columns if not col.get("autoincrement")]

        if not insertable:
            print("⚠️ No insertable columns found.")
            return

        values = {}
        print(f"\n📝 Enter values for table '{table_name}':")
        for col in insertable:
            col_name = col['name']
            col_type = col['type']
            val = input(f"{col_name} ({col_type}): ").strip()
            if val == "":
                val = None
            values[col_name] = val

        placeholders = ", ".join([f":{col}" for col in values])
        col_names = ", ".join(values.keys())

        query = text(f"INSERT INTO {table_name} ({col_names}) VALUES ({placeholders})")
        connection.execute(query, values)
        connection.commit()
        print("✅ Data inserted successfully!")

    except Exception as e:
        print(f"❌ Error: {e}")

def view_table(table_name):
    try:
        result = connection.execute(text(f"SELECT * FROM {table_name}"))
        rows = result.fetchall()
        print(f"\n📊 Data from '{table_name}':")
        if rows:
            for row in rows:
                print(dict(row._mapping))
        else:
            print("No data found.")
    except Exception as e:
        print(f"❌ Error: {e}")

def delete_from_table(table_name):
    try:
        pks = get_primary_keys(table_name)
        if not pks:
            print("⚠️ Cannot delete: No primary key defined.")
            return

        print(f"\n🗑️ To delete a row, enter values for the primary key(s): {pks}")
        conditions = []
        params = {}
        for pk in pks:
            val = input(f"{pk}: ").strip()
            if val == "":
                print("⚠️ Primary key cannot be empty.")
                return
            conditions.append(f"{pk} = :{pk}")
            params[pk] = val

        condition_str = " AND ".join(conditions)
        query = text(f"DELETE FROM {table_name} WHERE {condition_str}")
        result = connection.execute(query, params)
        connection.commit()

        if result.rowcount > 0:
            print("✅ Row deleted successfully!")
        else:
            print("⚠️ No matching record found.")

    except Exception as e:
        print(f"❌ Error: {e}")

# Order placement
def place_order():
    try:
        email = input("Customer Email: ").strip()
        customer_query = text("SELECT CustomerID FROM Customers WHERE Email = :email")
        result = connection.execute(customer_query, {"email": email}).fetchone()

        if result:
            customer_id = result[0]
            print(f"✅ Existing customer found: ID = {customer_id}")
        else:
            print("🆕 New customer:")
            customer_id = input("Customer ID: ").strip()
            name = input("Customer Name: ").strip()
            phone = input("Phone: ").strip()
            show_existing_address_ids()
            address_id = int(input("Address ID (must already exist): ").strip())
            loyalty_points = input("Loyalty Points (default 0): ").strip() or "0"

            insert_customer = text("""
                INSERT INTO Customers (CustomerID, CustomerName, Email, Phone, AddressID, LoyaltyPoints)
                VALUES (:id, :name, :email, :phone, :address_id, :points)
            """)
            connection.execute(insert_customer, {
                "id": customer_id,
                "name": name,
                "email": email,
                "phone": phone,
                "address_id": address_id,
                "points": loyalty_points
            })
            connection.commit()
            print(f"✅ New customer created: ID = {customer_id}")

        now = datetime.now()

        # 🔧 Manually get next OrderID
        order_id_result = connection.execute(text("SELECT MAX(OrderID) FROM Orders")).scalar()
        order_id = (order_id_result or 0) + 1

        order_insert = text("""
            INSERT INTO Orders (OrderID, CustomerID, OrderDate, Status, TotalAmount)
            VALUES (:order_id, :customer_id, :order_date, 'Pending', 0.0)
        """)
        connection.execute(order_insert, {
            "order_id": order_id,
            "customer_id": customer_id,
            "order_date": now
        })
        connection.commit()
        print(f"🧾 Order created: OrderID = {order_id}")

        total = 0.0

        while True:
            product_id = input("Product ID (or 'done'): ").strip()
            if product_id.lower() == "done":
                break
            quantity = int(input("Quantity: ").strip())

            price_query = text("SELECT Price FROM Products WHERE ProductID = :pid")
            price_result = connection.execute(price_query, {"pid": product_id}).fetchone()
            if not price_result:
                print("⚠️ Product not found.")
                continue
            price = float(price_result[0])
            subtotal = quantity * price

            # 🔧 Manually get next OrderDetailID
            detail_id_result = connection.execute(text("SELECT MAX(OrderDetailID) FROM OrderDetails")).scalar()
            order_detail_id = (detail_id_result or 0) + 1

            insert_detail = text("""
                INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, UnitPrice)
                VALUES (:odid, :oid, :pid, :qty, :price)
            """)
            connection.execute(insert_detail, {
                "odid": order_detail_id,
                "oid": order_id,
                "pid": product_id,
                "qty": quantity,
                "price": price
            })

            inventory_query = text("""
                SELECT InventoryID, QuantityInStock FROM Inventory
                WHERE ProductID = :pid AND QuantityInStock >= :qty
                ORDER BY QuantityInStock DESC
                LIMIT 1
            """)
            inv_result = connection.execute(inventory_query, {"pid": product_id, "qty": quantity}).fetchone()
            if inv_result:
                inventory_id, current_stock = inv_result
                update_inventory = text("""
                    UPDATE Inventory
                    SET QuantityInStock = QuantityInStock - :qty,
                        LastStockUpdate = :updated
                    WHERE InventoryID = :iid
                """)
                connection.execute(update_inventory, {
                    "qty": quantity,
                    "updated": datetime.now(),
                    "iid": inventory_id
                })
                print(f"📦 Inventory updated: -{quantity} units for ProductID {product_id}")
            else:
                print(f"⚠️ Not enough stock for ProductID {product_id}. Skipping inventory update.")

            total += subtotal

        update_total = text("UPDATE Orders SET TotalAmount = :total WHERE OrderID = :oid")
        connection.execute(update_total, {"total": total, "oid": order_id})

        assign = input("Assign an employee? (y/n): ").strip().lower()
        if assign == "y":
            emp_id = input("Employee ID: ").strip()
            emp_insert = text("INSERT INTO Employee_Orders (EmployeeID, OrderID) VALUES (:eid, :oid)")
            connection.execute(emp_insert, {"eid": emp_id, "oid": order_id})

        sale_id = input("Sale ID (or leave blank): ").strip()

        # 🔧 Manually get next PaymentID
        payment_id_result = connection.execute(text("SELECT MAX(PaymentID) FROM Payments")).scalar()
        payment_id = (payment_id_result or 0) + 1

        payment_insert = text("""
            INSERT INTO Payments (PaymentID, OrderID, CustomerID, SaleID, PaymentDate, Amount)
            VALUES (:pid, :oid, :cid, :sid, :date, :amount)
        """)
        connection.execute(payment_insert, {
            "pid": payment_id,
            "oid": order_id,
            "cid": customer_id,
            "sid": sale_id if sale_id else None,
            "date": now,
            "amount": total
        })

        connection.commit()
        print("🎉 Order placed and payment recorded successfully!")

    except Exception as e:
        connection.rollback()
        print(f"❌ Error: {e}")



# Main Menu
if __name__ == "__main__":
    print(f"✅ Connected to database: {database} at {host}:{port}")
    while True:
        print("\n🏠 Main Menu")
        print("1. Manage a table (insert/view/delete)")
        print("2. Place an order")
        print("3. Exit")
        choice = input("> ").strip()

        if choice == "1":
            tables = list_tables()
            t_choice = input("\nSelect a table by number or type 'back':\n> ").strip()
            if t_choice.lower() == "back":
                continue

            if not t_choice.isdigit() or int(t_choice) < 1 or int(t_choice) > len(tables):
                print("⚠️ Invalid selection.")
                continue

            table_name = tables[int(t_choice) - 1]

            while True:
                print(f"\n📍 Selected Table: {table_name}")
                print("1. Insert data")
                print("2. View data")
                print("3. Delete data")
                print("4. Choose another table")
                print("5. Main menu")

                action = input("> ").strip()

                if action == "1":
                    insert_into_table(table_name)
                elif action == "2":
                    view_table(table_name)
                elif action == "3":
                    delete_from_table(table_name)
                elif action == "4":
                    break
                elif action == "5":
                    break
                else:
                    print("⚠️ Invalid option.")

        elif choice == "2":
            place_order()

        elif choice == "3":
            connection.close()
            print("🔌 Connection closed.")
            break
        else:
            print("⚠️ Invalid option.")
