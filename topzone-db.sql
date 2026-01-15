CREATE TABLE roles (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255),
    full_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
	role_id UUID NOT NULL REFERENCES roles(id),
	auth_provider VARCHAR(50) NOT NULL,
	google_id VARCHAR(255) UNIQUE,
	avatar_url TEXT,
	email_verified BOOLEAN DEFAULT FALSE,
	created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE refresh_tokens (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token TEXT NOT NULL UNIQUE,
    auth_provider VARCHAR(50),
    user_agent TEXT,
    ip_address INET,
    is_revoked BOOLEAN DEFAULT FALSE,
    expires_at TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);


CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(150) UNIQUE NOT NULL,
	parent_id UUID REFERENCES categories(id),
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE images (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    origin_name VARCHAR(255) NOT NULL,
    stored_name VARCHAR(255) NOT NULL,
    mime_type VARCHAR(100) NOT NULL,
    image_size BIGINT NOT NULL,
    image_url TEXT NOT NULL,
    uploaded_by UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
	product_code VARCHAR(100) UNIQUE NOT NULL,
    category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    price NUMERIC(12,2) NOT NULL,
    discount NUMERIC(5,2) DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    is_archive BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE product_variants (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
	sku VARCHAR(150) UNIQUE NOT NULL,
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    variant_price NUMERIC(12,2),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
	
);

CREATE TABLE attributes (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    code VARCHAR(100) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    data_type VARCHAR(20) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE attribute_values (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    attribute_id UUID NOT NULL REFERENCES attributes(id) ON DELETE CASCADE,
    value_text TEXT,
    value_number NUMERIC,
    value_boolean BOOLEAN,
	created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE variant_attributes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    variant_id UUID NOT NULL REFERENCES product_variants(id) ON DELETE CASCADE,
    attribute_id UUID NOT NULL REFERENCES attributes(id) ON DELETE CASCADE,
    attribute_value_id UUID NOT NULL REFERENCES attribute_values(id) ON DELETE CASCADE,

    UNIQUE (variant_id, attribute_id)
);

CREATE TABLE product_images (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    image_id UUID NOT NULL REFERENCES images(id) ON DELETE CASCADE,
    is_primary BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_users_role_id ON users(role_id);

CREATE INDEX idx_users_google_login ON users(auth_provider, google_id);

CREATE INDEX idx_refresh_tokens_user_id ON refresh_tokens(user_id);

CREATE INDEX idx_refresh_tokens_expires_at ON refresh_tokens(expires_at);

CREATE INDEX idx_categories_parent_id ON categories(parent_id);

CREATE INDEX idx_products_category_id ON products(category_id);

CREATE INDEX idx_variants_product_id ON product_variants(product_id);

CREATE INDEX idx_variant_attributes_attribute ON variant_attributes(attribute_id);

CREATE UNIQUE INDEX ux_product_primary_image ON product_images(product_id) WHERE is_primary = TRUE;



