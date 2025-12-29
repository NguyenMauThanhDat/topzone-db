
-- ===== 1. ENUM TYPES =====
CREATE TYPE order_status AS ENUM (
    'PENDING', 'PAID', 'SHIPPED', 'DELIVERED', 'CANCELLED'
);

CREATE TYPE payment_method AS ENUM (
    'CREDIT_CARD', 'BANK_TRANSFER', 'E_WALLET', 'CASH_ON_DELIVERY'
);

CREATE TYPE payment_status AS ENUM (
    'SUCCESS', 'FAILED', 'PENDING'
);

CREATE TYPE warranty_status AS ENUM (
    'REQUESTED', 'APPROVED', 'REJECTED', 'COMPLETED'
);

-- ===== 2. USERS =====
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===== 3. CATEGORIES (SELF REFERENCE) =====
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(150) UNIQUE NOT NULL,
    description TEXT,
    parent_id INT REFERENCES categories(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===== 4. PRODUCTS =====
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    category_id INT NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    price NUMERIC(12,2) NOT NULL,
    stock INT DEFAULT 0 CHECK (stock >= 0),
    image_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===== 5. ORDERS =====
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status order_status DEFAULT 'PENDING',
    total_amount NUMERIC(12,2) NOT NULL,
    shipping_address TEXT NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===== 6. ORDER ITEMS =====
CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id INT NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(12,2) NOT NULL
);

-- ===== 7. PAYMENTS =====
CREATE TABLE payments (
    id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount NUMERIC(12,2) NOT NULL,
    method payment_method NOT NULL,
    status payment_status DEFAULT 'PENDING'
);

-- ===== 8. WARRANTIES =====
CREATE TABLE warranties (
    id SERIAL PRIMARY KEY,
    order_item_id INT NOT NULL REFERENCES order_items(id) ON DELETE CASCADE,
    warranty_status warranty_status DEFAULT 'REQUESTED',
    request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    details TEXT,
    resolution_date TIMESTAMP
);

-- ===== END FILE =====
