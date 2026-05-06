-- CreateTable
CREATE TABLE "commerce_accounts" (
    "id" BIGSERIAL NOT NULL,
    "owner_user_id" BIGINT NOT NULL,
    "slug" VARCHAR(100) NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "description" TEXT,
    "status" VARCHAR(30) NOT NULL DEFAULT 'pending_verification',
    "created_at" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "commerce_accounts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "commerce_account_members" (
    "id" BIGSERIAL NOT NULL,
    "commerce_account_id" BIGINT NOT NULL,
    "user_id" BIGINT NOT NULL,
    "role" VARCHAR(30) NOT NULL,
    "created_at" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),

    CONSTRAINT "commerce_account_members_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "addresses" (
    "id" BIGSERIAL NOT NULL,
    "addressable_type" VARCHAR(100) NOT NULL,
    "addressable_id" BIGINT NOT NULL,
    "label" VARCHAR(50),
    "recipient_name" VARCHAR(255) NOT NULL,
    "phone" VARCHAR(20) NOT NULL,
    "province_id" INTEGER NOT NULL,
    "city_id" INTEGER NOT NULL,
    "subdistrict_id" INTEGER,
    "postal_code" VARCHAR(10),
    "street_address" TEXT NOT NULL,
    "is_default" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),

    CONSTRAINT "addresses_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "commerce_accounts_slug_key" ON "commerce_accounts"("slug");

-- CreateIndex
CREATE INDEX "commerce_accounts_slug_idx" ON "commerce_accounts"("slug");

-- CreateIndex
CREATE INDEX "commerce_accounts_status_idx" ON "commerce_accounts"("status");

-- CreateIndex
CREATE UNIQUE INDEX "commerce_account_members_commerce_account_id_user_id_key" ON "commerce_account_members"("commerce_account_id", "user_id");

-- CreateIndex
CREATE INDEX "addresses_addressable_type_addressable_id_idx" ON "addresses"("addressable_type", "addressable_id");

-- AddForeignKey
ALTER TABLE "commerce_accounts" ADD CONSTRAINT "commerce_accounts_owner_user_id_fkey" FOREIGN KEY ("owner_user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "commerce_account_members" ADD CONSTRAINT "commerce_account_members_commerce_account_id_fkey" FOREIGN KEY ("commerce_account_id") REFERENCES "commerce_accounts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "commerce_account_members" ADD CONSTRAINT "commerce_account_members_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
