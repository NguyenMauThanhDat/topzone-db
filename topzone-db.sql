CREATE TABLE roles (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
	updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255),
    full_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
	role_id UUID NOT NULL
        REFERENCES roles(id),
        
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

	auth_provider VARCHAR(50) NOT NULL,
	google_id VARCHAR(255) UNIQUE,
	avatar_url TEXT,
	email_verified BOOLEAN DEFAULT FALSE
);

CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(150) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE images (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    origin_name VARCHAR(255) NOT NULL,
    stored_name VARCHAR(255) NOT NULL,
    mime_type VARCHAR(100) NOT NULL,
    image_size BIGINT NOT NULL,
    image_url TEXT NOT NULL,
    uploaded_by UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT uuidv7(),

    category_id UUID 
        REFERENCES categories(id) 
        ON DELETE SET NULL,

    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    price NUMERIC(12,2) NOT NULL,

    discount NUMERIC(5,2) DEFAULT 0
        CHECK (discount >= 0 AND discount <= 100),

    is_active BOOLEAN DEFAULT TRUE,
    is_archive BOOLEAN DEFAULT FALSE,

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE product_variants (
    id UUID PRIMARY KEY DEFAULT uuidv7(),

    product_id UUID NOT NULL
        REFERENCES products(id)
        ON DELETE CASCADE,

    size VARCHAR(50) NOT NULL,
    color VARCHAR(50) NOT NULL,

    variant_price NUMERIC(12,2),

    is_active BOOLEAN DEFAULT TRUE,

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

    UNIQUE (product_id, size, color)
);

CREATE TABLE product_images (
    id UUID PRIMARY KEY DEFAULT uuidv7(),

    product_id UUID NOT NULL
        REFERENCES products(id)
        ON DELETE CASCADE,

    image_id UUID NOT NULL
        REFERENCES images(id)
        ON DELETE CASCADE,

    is_primary BOOLEAN DEFAULT FALSE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);


