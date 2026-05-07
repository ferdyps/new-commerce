-- CreateTable
CREATE TABLE "channel_templates" (
    "id" BIGSERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "slug" VARCHAR(100) NOT NULL,
    "preview_image_url" VARCHAR(500),
    "default_layout" JSONB NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),

    CONSTRAINT "channel_templates_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "channels" (
    "id" BIGSERIAL NOT NULL,
    "commerce_account_id" BIGINT NOT NULL,
    "shop_id" BIGINT NOT NULL,
    "template_id" BIGINT,
    "slug" VARCHAR(100) NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "layout" JSONB NOT NULL,
    "meta_title" VARCHAR(255),
    "meta_description" VARCHAR(500),
    "og_image_url" VARCHAR(500),
    "visitor_count" BIGINT NOT NULL DEFAULT 0,
    "status" VARCHAR(20) NOT NULL DEFAULT 'draft',
    "published_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "channels_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "channel_products" (
    "id" BIGSERIAL NOT NULL,
    "channel_id" BIGINT NOT NULL,
    "product_id" BIGINT NOT NULL,
    "sort_order" INTEGER NOT NULL DEFAULT 0,
    "is_featured" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),

    CONSTRAINT "channel_products_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "channel_visits" (
    "id" BIGSERIAL NOT NULL,
    "channel_id" BIGINT NOT NULL,
    "visitor_hash" VARCHAR(64) NOT NULL,
    "referrer" VARCHAR(500),
    "country_code" VARCHAR(2),
    "visited_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "channel_visits_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "channel_templates_slug_key" ON "channel_templates"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "channels_slug_key" ON "channels"("slug");

-- CreateIndex
CREATE INDEX "channels_slug_idx" ON "channels"("slug");

-- CreateIndex
CREATE INDEX "channels_status_idx" ON "channels"("status");

-- CreateIndex
CREATE INDEX "channels_commerce_account_id_idx" ON "channels"("commerce_account_id");

-- CreateIndex
CREATE UNIQUE INDEX "channel_products_channel_id_product_id_key" ON "channel_products"("channel_id", "product_id");

-- CreateIndex
CREATE INDEX "channel_visits_channel_id_visited_at_idx" ON "channel_visits"("channel_id", "visited_at");

-- AddForeignKey
ALTER TABLE "channels" ADD CONSTRAINT "channels_commerce_account_id_fkey" FOREIGN KEY ("commerce_account_id") REFERENCES "commerce_accounts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "channels" ADD CONSTRAINT "channels_shop_id_fkey" FOREIGN KEY ("shop_id") REFERENCES "shops"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "channels" ADD CONSTRAINT "channels_template_id_fkey" FOREIGN KEY ("template_id") REFERENCES "channel_templates"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "channel_products" ADD CONSTRAINT "channel_products_channel_id_fkey" FOREIGN KEY ("channel_id") REFERENCES "channels"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "channel_products" ADD CONSTRAINT "channel_products_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "products"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "channel_visits" ADD CONSTRAINT "channel_visits_channel_id_fkey" FOREIGN KEY ("channel_id") REFERENCES "channels"("id") ON DELETE CASCADE ON UPDATE CASCADE;
