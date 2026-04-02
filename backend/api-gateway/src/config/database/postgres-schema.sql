-- ════════════════════════════════════════════════════════════════════════════
-- Study Buddy - PostgreSQL Database Schema
-- ════════════════════════════════════════════════════════════════════════════
-- Database: studybuddy_users
-- Purpose: Relational data for users, authentication, profiles, enrollments
-- ════════════════════════════════════════════════════════════════════════════

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ── Users Table ─────────────────────────────────────────────────────────────
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL DEFAULT 'student',
    school_name VARCHAR(255),
    grade_level VARCHAR(50),
    profile_image_url VARCHAR(500),
    email_verified BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    last_login_at TIMESTAMP WITH TIME ZONE
);

-- Index for faster login queries
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);

-- ── User Profiles Table ─────────────────────────────────────────────────────
CREATE TABLE user_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    phone_number VARCHAR(50),
    date_of_birth DATE,
    gender VARCHAR(50),
    address TEXT,
    city VARCHAR(100),
    province VARCHAR(100),
    postal_code VARCHAR(20),
    parent_name VARCHAR(255),
    parent_phone VARCHAR(50),
    learning_style VARCHAR(50), -- visual, auditory, kinesthetic
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_user_profiles_user_id ON user_profiles(user_id);
CREATE INDEX idx_user_profiles_learning_style ON user_profiles(learning_style);

-- ── Refresh Tokens Table ────────────────────────────────────────────────────
CREATE TABLE refresh_tokens (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token VARCHAR(500) UNIQUE NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    is_revoked BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    revoked_at TIMESTAMP WITH TIME ZONE
);

CREATE INDEX idx_refresh_tokens_user_id ON refresh_tokens(user_id);
CREATE INDEX idx_refresh_tokens_token ON refresh_tokens(token);

-- ── VAK Assessment Results ──────────────────────────────────────────────────
CREATE TABLE vak_results (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    visual_score DECIMAL(5,4) NOT NULL,
    auditory_score DECIMAL(5,4) NOT NULL,
    kinesthetic_score DECIMAL(5,4) NOT NULL,
    dominant_style VARCHAR(50) NOT NULL,
    confidence_score DECIMAL(5,4),
    completed_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    answers JSONB NOT NULL, -- Store individual answers
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_vak_results_user_id ON vak_results(user_id);
CREATE INDEX idx_vak_results_dominant_style ON vak_results(dominant_style);

-- ── User Stats / Gamification ───────────────────────────────────────────────
CREATE TABLE user_stats (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    xp INTEGER NOT NULL DEFAULT 0,
    level INTEGER NOT NULL DEFAULT 1,
    quizzes_completed INTEGER NOT NULL DEFAULT 0,
    quizzes_passed INTEGER NOT NULL DEFAULT 0,
    average_score DECIMAL(5,2) DEFAULT 0,
    study_streak_days INTEGER NOT NULL DEFAULT 0,
    total_study_minutes INTEGER NOT NULL DEFAULT 0,
    badges JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_user_stats_user_id ON user_stats(user_id);
CREATE INDEX idx_user_stats_xp ON user_stats(xp DESC);
CREATE INDEX idx_user_stats_level ON user_stats(level DESC);

-- ── Audit Logs ──────────────────────────────────────────────────────────────
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(100),
    entity_id UUID,
    old_value JSONB,
    new_value JSONB,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_action ON audit_logs(action);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at);

-- ── Password Reset Tokens ───────────────────────────────────────────────────
CREATE TABLE password_reset_tokens (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token VARCHAR(255) UNIQUE NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    used BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_password_reset_tokens_user_id ON password_reset_tokens(user_id);
CREATE INDEX idx_password_reset_tokens_token ON password_reset_tokens(token);

-- ── Update Timestamp Trigger Function ───────────────────────────────────────
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply trigger to tables with updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_profiles_updated_at BEFORE UPDATE ON user_profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_stats_updated_at BEFORE UPDATE ON user_stats
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ── Initial Data ────────────────────────────────────────────────────────────
-- Default admin user (password: admin123 - change in production!)
INSERT INTO users (email, password_hash, name, role, email_verified)
VALUES (
    'admin@studybuddy.id',
    '$2b$10$example_hash_replace_in_production',
    'Admin Study Buddy',
    'admin',
    TRUE
);

-- Comments
COMMENT ON TABLE users IS 'User accounts for students, teachers, and admins';
COMMENT ON TABLE user_profiles IS 'Extended user profile information';
COMMENT ON TABLE user_stats IS 'Gamification stats: XP, level, achievements';
COMMENT ON TABLE vak_results IS 'VAK learning style assessment results';
COMMENT ON TABLE audit_logs IS 'System audit trail for security';
