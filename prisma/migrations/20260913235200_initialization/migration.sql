-- CreateTable
CREATE TABLE `users` (
    `id` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `email` VARCHAR(191) NOT NULL,
    `image` VARCHAR(191) NULL,
    `verified_at` DATETIME(3) NULL,
    `deleted_at` DATETIME(3) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `users_email_key`(`email`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `accounts` (
    `id` VARCHAR(191) NOT NULL,
    `user_id` VARCHAR(191) NOT NULL,
    `account_id` VARCHAR(191) NOT NULL,
    `provider_id` ENUM('CREDENTIALS', 'GOOGLE') NOT NULL,
    `accessToken` TEXT NULL,
    `refreshToken` TEXT NULL,
    `access_token_expired_at` DATETIME(3) NULL,
    `refresh_token_expired_at` DATETIME(3) NULL,
    `scope` VARCHAR(191) NULL,
    `idToken` TEXT NULL,
    `password` VARCHAR(191) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `accounts_user_id_provider_id_key`(`user_id`, `provider_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `sessions` (
    `id` VARCHAR(191) NOT NULL,
    `user_id` VARCHAR(191) NOT NULL,
    `token` VARCHAR(191) NOT NULL,
    `expired_at` DATETIME(3) NOT NULL,
    `ip_address` VARCHAR(191) NULL,
    `user_agent` VARCHAR(191) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `session_token_idx`(`token`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `verifications` (
    `id` VARCHAR(191) NOT NULL,
    `user_id` VARCHAR(191) NOT NULL,
    `type` ENUM('EMAIL_VERIFICATION', 'PASSWORD_RESET', 'ORDER_CONFIRMATION') NOT NULL,
    `token_hash` VARCHAR(191) NOT NULL,
    `code` VARCHAR(191) NULL,
    `expired_at` DATETIME(3) NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `roles` (
    `id` VARCHAR(191) NOT NULL,
    `name` ENUM('USER', 'ADMIN', 'SUPERADMIN') NOT NULL,
    `is_active` BOOLEAN NOT NULL DEFAULT true,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `roles_name_key`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `user_roles` (
    `id` VARCHAR(191) NOT NULL,
    `user_id` VARCHAR(191) NOT NULL,
    `role_id` VARCHAR(191) NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `user_roles_user_id_role_id_key`(`user_id`, `role_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `researches` (
    `id` VARCHAR(191) NOT NULL,
    `researcher_id` VARCHAR(191) NOT NULL,
    `title` VARCHAR(255) NOT NULL,
    `description` VARCHAR(191) NOT NULL,
    `external_survey_url` VARCHAR(191) NOT NULL,
    `target_respondent_count` INTEGER NOT NULL,
    `estimated_duration_minutes` INTEGER NOT NULL,
    `deadline` DATETIME(3) NOT NULL,
    `status` VARCHAR(30) NOT NULL,
    `published_at` DATETIME(3) NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `research_token_budgets` (
    `id` VARCHAR(191) NOT NULL,
    `research_id` VARCHAR(191) NOT NULL,
    `total_token_amount` DECIMAL(12, 2) NOT NULL,
    `respondent_pool_amount` DECIMAL(12, 2) NOT NULL,
    `platform_fee_amount` DECIMAL(12, 2) NOT NULL,
    `reward_per_respondent` DECIMAL(12, 2) NOT NULL,
    `consumed_respondent_token` DECIMAL(12, 2) NOT NULL,
    `consumed_platform_token` DECIMAL(12, 2) NOT NULL,

    UNIQUE INDEX `research_token_budgets_research_id_key`(`research_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `research_criterions` (
    `id` VARCHAR(191) NOT NULL,
    `research_id` VARCHAR(191) NOT NULL,
    `field` VARCHAR(50) NOT NULL,
    `operator` VARCHAR(20) NOT NULL,
    `value` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `screening_questions` (
    `id` VARCHAR(191) NOT NULL,
    `research_id` VARCHAR(191) NOT NULL,
    `question_text` TEXT NOT NULL,
    `question_json` JSON NULL,
    `scoring_weight` INTEGER NOT NULL,
    `scoring_weight_json` JSON NULL,
    `pass_threshold` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `participations` (
    `id` VARCHAR(191) NOT NULL,
    `research_id` VARCHAR(191) NOT NULL,
    `respondent_id` VARCHAR(191) NOT NULL,
    `status` ENUM('INVITED', 'SCREENING', 'ACCEPTED', 'REJECTED', 'SUBMITTED', 'COMPLETED', 'REWARDED') NOT NULL,
    `screening_score` INTEGER NULL,
    `submitted_at` DATETIME(3) NULL,
    `auto_screening_result` VARCHAR(191) NULL,
    `admin_reviewed_by` VARCHAR(191) NULL,
    `admin_reviewed_at` DATETIME(3) NULL,
    `hold_released_at` DATETIME(3) NULL,
    `rewarded_at` DATETIME(3) NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `screening_answers` (
    `id` VARCHAR(191) NOT NULL,
    `participation_id` VARCHAR(191) NOT NULL,
    `screening_question_id` VARCHAR(191) NOT NULL,
    `answer` TEXT NOT NULL,
    `score` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `quality_check` (
    `id` VARCHAR(191) NOT NULL,
    `participation_id` VARCHAR(191) NOT NULL,
    `signal_flags` JSON NULL,
    `auto_score` DECIMAL(5, 2) NULL,
    `reviewed_by` VARCHAR(191) NULL,
    `decision` VARCHAR(20) NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `rewards` (
    `id` VARCHAR(191) NOT NULL,
    `participation_id` VARCHAR(191) NOT NULL,
    `token_amount` DECIMAL(12, 2) NOT NULL,
    `status` VARCHAR(191) NOT NULL,
    `paid_at` DATETIME(3) NULL,

    UNIQUE INDEX `rewards_participation_id_key`(`participation_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `content_report` (
    `id` VARCHAR(191) NOT NULL,
    `research_id` VARCHAR(191) NOT NULL,
    `reported_by` VARCHAR(191) NULL,
    `reason` TEXT NOT NULL,
    `status` ENUM('PENDING', 'REVIEWING', 'RESOLVED', 'DISMISSED') NOT NULL,
    `reviewed_by` VARCHAR(191) NULL,
    `action_taken` ENUM('NONE', 'WARNING', 'SUSPENSION', 'BAN', 'REMOVED_CONTENT') NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `support_ticket` (
    `id` VARCHAR(191) NOT NULL,
    `user_id` VARCHAR(191) NOT NULL,
    `category` ENUM('GENERAL', 'BILLING', 'TECHNICAL', 'ACCOUNT') NOT NULL,
    `subject` VARCHAR(255) NOT NULL,
    `description` TEXT NOT NULL,
    `status` ENUM('OPEN', 'IN_PROGRESS', 'RESOLVED', 'CLOSED') NOT NULL,
    `assigned_to` VARCHAR(191) NULL,
    `resolved_at` DATETIME(3) NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `admin_review` (
    `id` VARCHAR(191) NOT NULL,
    `admin_id` VARCHAR(191) NOT NULL,
    `admin_role` ENUM('USER', 'ADMIN', 'SUPERADMIN') NOT NULL,
    `target_type` ENUM('RESEARCH', 'PARTICIPATION', 'USER', 'PAYMENT', 'SUPPORT_TICKET', 'CONTENT_REPORT') NOT NULL,
    `target_id` VARCHAR(191) NOT NULL,
    `action` ENUM('APPROVE', 'REJECT', 'HOLD', 'ESCALATE') NOT NULL,
    `note` TEXT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `token_transactions` (
    `id` VARCHAR(191) NOT NULL,
    `wallet_id` VARCHAR(191) NOT NULL,
    `research_id` VARCHAR(191) NULL,
    `participation_id` VARCHAR(191) NULL,
    `transaction_type` ENUM('RESEARCH_PAYMENT', 'RESPONDENT_REWARD', 'PLATFORM_FEE', 'TOP_UP', 'REFUND', 'ADJUSTMENT') NOT NULL,
    `amount` DECIMAL(12, 2) NOT NULL,
    `reference_id` VARCHAR(255) NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `withdrawal` (
    `id` VARCHAR(191) NOT NULL,
    `user_id` VARCHAR(191) NOT NULL,
    `token_amount` INTEGER NOT NULL,
    `fee_percentage` DECIMAL(4, 2) NOT NULL,
    `net_amount_idr` DECIMAL(12, 2) NOT NULL,
    `status` ENUM('PENDING', 'APPROVED', 'REJECTED', 'PROCESSING', 'COMPLETED', 'FAILED') NOT NULL,
    `approved_by` VARCHAR(191) NULL,
    `payment_provider_ref` VARCHAR(255) NULL,
    `processed_at` DATETIME(3) NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `payment` (
    `id` VARCHAR(191) NOT NULL,
    `user_id` VARCHAR(191) NOT NULL,
    `type` ENUM('TOP_UP', 'RESEARCH_PAYMENT', 'REFUND') NOT NULL,
    `provider` ENUM('MIDTRANS', 'XENDIT', 'STRIPE', 'MANUAL') NOT NULL,
    `provider_ref` VARCHAR(255) NULL,
    `amount_idr` DECIMAL(12, 2) NOT NULL,
    `status` ENUM('PENDING', 'SUCCESS', 'FAILED', 'EXPIRED', 'REFUNDED') NOT NULL,
    `idempotency_key` VARCHAR(255) NULL,

    UNIQUE INDEX `payment_provider_ref_key`(`provider_ref`),
    UNIQUE INDEX `payment_idempotency_key_key`(`idempotency_key`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `notification` (
    `id` VARCHAR(191) NOT NULL,
    `user_id` VARCHAR(191) NOT NULL,
    `type` ENUM('SYSTEM', 'TRANSACTION', 'RESEARCH_INVITATION', 'RESEARCH_UPDATE', 'SUPPORT_TICKET', 'WITHDRAWAL_UPDATE') NOT NULL,
    `message` TEXT NOT NULL,
    `read_at` DATETIME(3) NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `user_profiles` (
    `id` VARCHAR(191) NOT NULL,
    `user_id` VARCHAR(191) NOT NULL,
    `gender` ENUM('MALE', 'FEMALE', 'OTHER', 'PREFER_NOT_TO_SAY') NOT NULL,
    `religion` VARCHAR(191) NULL,
    `religion_consent_at` DATETIME(3) NULL,
    `domicile_province` VARCHAR(191) NULL,
    `domicile_city` VARCHAR(191) NULL,
    `domicile_latitude` VARCHAR(191) NULL,
    `domicile_longitude` VARCHAR(191) NULL,
    `domicile_verified_at` DATETIME(3) NULL,
    `education` VARCHAR(191) NULL,
    `occupation` VARCHAR(191) NULL,
    `data_share_consent_at` DATETIME(3) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `user_profiles_user_id_key`(`user_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `token_wallets` (
    `id` VARCHAR(191) NOT NULL,
    `user_id` VARCHAR(191) NOT NULL,
    `token_balance` DECIMAL(12, 2) NOT NULL,

    UNIQUE INDEX `token_wallets_user_id_key`(`user_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `accounts` ADD CONSTRAINT `accounts_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `sessions` ADD CONSTRAINT `sessions_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `verifications` ADD CONSTRAINT `verifications_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `user_roles` ADD CONSTRAINT `user_roles_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `user_roles` ADD CONSTRAINT `user_roles_role_id_fkey` FOREIGN KEY (`role_id`) REFERENCES `roles`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `researches` ADD CONSTRAINT `researches_researcher_id_fkey` FOREIGN KEY (`researcher_id`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `research_token_budgets` ADD CONSTRAINT `research_token_budgets_research_id_fkey` FOREIGN KEY (`research_id`) REFERENCES `researches`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `research_criterions` ADD CONSTRAINT `research_criterions_research_id_fkey` FOREIGN KEY (`research_id`) REFERENCES `researches`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `screening_questions` ADD CONSTRAINT `screening_questions_research_id_fkey` FOREIGN KEY (`research_id`) REFERENCES `researches`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `participations` ADD CONSTRAINT `participations_research_id_fkey` FOREIGN KEY (`research_id`) REFERENCES `researches`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `participations` ADD CONSTRAINT `participations_respondent_id_fkey` FOREIGN KEY (`respondent_id`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `participations` ADD CONSTRAINT `participations_admin_reviewed_by_fkey` FOREIGN KEY (`admin_reviewed_by`) REFERENCES `users`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `screening_answers` ADD CONSTRAINT `screening_answers_participation_id_fkey` FOREIGN KEY (`participation_id`) REFERENCES `participations`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `screening_answers` ADD CONSTRAINT `screening_answers_screening_question_id_fkey` FOREIGN KEY (`screening_question_id`) REFERENCES `screening_questions`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `quality_check` ADD CONSTRAINT `quality_check_participation_id_fkey` FOREIGN KEY (`participation_id`) REFERENCES `participations`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `rewards` ADD CONSTRAINT `rewards_participation_id_fkey` FOREIGN KEY (`participation_id`) REFERENCES `participations`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `content_report` ADD CONSTRAINT `content_report_research_id_fkey` FOREIGN KEY (`research_id`) REFERENCES `researches`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `content_report` ADD CONSTRAINT `content_report_reported_by_fkey` FOREIGN KEY (`reported_by`) REFERENCES `users`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `content_report` ADD CONSTRAINT `content_report_reviewed_by_fkey` FOREIGN KEY (`reviewed_by`) REFERENCES `users`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `support_ticket` ADD CONSTRAINT `support_ticket_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `support_ticket` ADD CONSTRAINT `support_ticket_assigned_to_fkey` FOREIGN KEY (`assigned_to`) REFERENCES `users`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `admin_review` ADD CONSTRAINT `admin_review_admin_id_fkey` FOREIGN KEY (`admin_id`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `token_transactions` ADD CONSTRAINT `token_transactions_wallet_id_fkey` FOREIGN KEY (`wallet_id`) REFERENCES `token_wallets`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `token_transactions` ADD CONSTRAINT `token_transactions_research_id_fkey` FOREIGN KEY (`research_id`) REFERENCES `researches`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `token_transactions` ADD CONSTRAINT `token_transactions_participation_id_fkey` FOREIGN KEY (`participation_id`) REFERENCES `participations`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `withdrawal` ADD CONSTRAINT `withdrawal_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `withdrawal` ADD CONSTRAINT `withdrawal_approved_by_fkey` FOREIGN KEY (`approved_by`) REFERENCES `users`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `payment` ADD CONSTRAINT `payment_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `notification` ADD CONSTRAINT `notification_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `user_profiles` ADD CONSTRAINT `user_profiles_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `token_wallets` ADD CONSTRAINT `token_wallets_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
