-- ============================================================
-- 个人成长工作台 - Supabase 建表脚本
-- ============================================================
-- 使用方法：
-- 1. 登录 https://supabase.com 创建新项目
-- 2. 进入 SQL Editor
-- 3. 粘贴此脚本并执行
-- 4. 执行完成后，前往 Settings > API
-- 5. 复制 Project URL 和 anon public key 填入工作台配置面板
-- ============================================================

-- 创建数据表
CREATE TABLE IF NOT EXISTS growth_records (
  id TEXT PRIMARY KEY,
  module TEXT NOT NULL DEFAULT 'fitness',
  title TEXT NOT NULL DEFAULT '',
  date TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  checked BOOLEAN NOT NULL DEFAULT FALSE,
  detail JSONB NOT NULL DEFAULT '{}'::jsonb,
  repeat TEXT NOT NULL DEFAULT 'none',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 创建索引（加速查询）
CREATE INDEX IF NOT EXISTS idx_growth_records_date ON growth_records(date);
CREATE INDEX IF NOT EXISTS idx_growth_records_module ON growth_records(module);
CREATE INDEX IF NOT EXISTS idx_growth_records_updated ON growth_records(updated_at DESC);

-- 自动更新 updated_at 触发器
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER IF NOT EXISTS trg_growth_records_updated
  BEFORE UPDATE ON growth_records
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

-- ============================================================
-- RLS (Row Level Security) 策略
-- ============================================================
-- 启用 RLS
ALTER TABLE growth_records ENABLE ROW LEVEL SECURITY;

-- 允许匿名用户读取所有数据（使用 anon key 即可访问）
CREATE POLICY "Allow anonymous read" ON growth_records
  FOR SELECT USING (true);

-- 允许匿名用户插入数据
CREATE POLICY "Allow anonymous insert" ON growth_records
  FOR INSERT WITH CHECK (true);

-- 允许匿名用户更新数据
CREATE POLICY "Allow anonymous update" ON growth_records
  FOR UPDATE USING (true);

-- 允许匿名用户删除数据
CREATE POLICY "Allow anonymous delete" ON growth_records
  FOR DELETE USING (true);

-- ============================================================
-- 说明：
-- 以上 RLS 策略允许任何持有 anon key 的人进行完整 CRUD 操作。
-- 适用于个人使用场景。如需更高安全性，可改为：
-- 1. 禁用匿名策略
-- 2. 创建认证策略（USING auth.uid() IS NOT NULL）
-- 3. 在工作台中集成 Supabase Auth 登录功能
-- ============================================================
