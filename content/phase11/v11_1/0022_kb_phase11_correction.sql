-- TCRMHC Phase 11 correction
-- Removes unsupported Workspace/Inbox help content and keeps only evidenced Support Center guidance.

BEGIN;

DO $$
DECLARE
  owner_tenant UUID;
  v_module_id UUID;
  v_support_cat_id UUID;
BEGIN
  SELECT id, tenant_id
  INTO v_module_id, owner_tenant
  FROM kb_modules
  WHERE slug = 'tcrm'
    AND status = 'active'
  ORDER BY created_at, id
  LIMIT 1;

  IF v_module_id IS NULL OR owner_tenant IS NULL THEN
    RAISE EXCEPTION 'TCRMHC_PHASE11_CORRECTION_REQUIRES_TCRM_MODULE';
  END IF;

  DELETE FROM kb_articles
  WHERE tenant_id = owner_tenant
    AND module_id = v_module_id
    AND slug IN ('tcrm-workspace-guide','tcrm-inbox-management');

  DELETE FROM kb_categories c
  WHERE c.tenant_id = owner_tenant
    AND c.module_id = v_module_id
    AND c.slug IN ('tcrm-workspace','tcrm-inbox')
    AND NOT EXISTS (
      SELECT 1 FROM kb_articles a WHERE a.category_id = c.id
    );

  INSERT INTO kb_categories (
    tenant_id,module_id,title_ar,title_en,slug,status,sort_order,created_at,updated_at
  ) VALUES (
    owner_tenant,v_module_id,'مركز المساعدة','Support Center','tcrm-support-center','active',11,NOW(),NOW()
  )
  ON CONFLICT (tenant_id, slug) DO UPDATE SET
    module_id = EXCLUDED.module_id,
    title_ar = EXCLUDED.title_ar,
    title_en = EXCLUDED.title_en,
    status = EXCLUDED.status,
    updated_at = NOW();

  SELECT id INTO v_support_cat_id
  FROM kb_categories
  WHERE tenant_id = owner_tenant AND slug = 'tcrm-support-center'
  LIMIT 1;

  IF v_support_cat_id IS NULL THEN
    RAISE EXCEPTION 'TCRMHC_PHASE11_CORRECTION_REQUIRES_SUPPORT_CATEGORY';
  END IF;

  INSERT INTO kb_articles (
    tenant_id,module_id,category_id,subcategory_id,slug,title_ar,title_en,excerpt_ar,excerpt_en,
    body_ar,body_en,status,sort_order,seo_title_ar,seo_title_en,seo_description_ar,seo_description_en,
    published_at,visibility_scope,consumer_hidden,canonical_article_id,media
  ) VALUES (
    owner_tenant,
    v_module_id,
    v_support_cat_id,
    NULL,
    'tcrm-support-center-guide',
    'مركز المساعدة في TCRM - دليل الاستخدام',
    'TCRM Help Center - Usage Guide',
    'تعرّف على استخدام مركز المساعدة وفتح المقالات والاستفادة من مساعد الدعم الذكي وإرسال تقييمك على المحتوى.',
    'Learn how to use the Help Center, open help articles, use the AI support assistant, and send article feedback.',
    $ar$مركز المساعدة في TCRM هو المكان المخصص للوصول إلى محتوى الدعم المنشور داخل النظام.

1. افتح مركز المساعدة
انتقل إلى مركز المساعدة من داخل TCRM. المسار المستخدم في النظام هو /app/help.

2. افتح مقال المساعدة المناسب
من الصفحة الرئيسية لمركز المساعدة يمكنك الانتقال إلى المقالات المنشورة وفتح المقال الذي يشرح الموضوع الذي تحتاجه. لكل مقال صفحة مخصصة لعرض محتواه.

3. استخدم مساعد الدعم الذكي
يتضمن مركز المساعدة مساعد دعم ذكي يساعدك على فهم المعلومات المتاحة. يعتمد المساعد على محتوى قاعدة المعرفة المنشور داخل مركز المساعدة، لذلك استخدمه لطلب توضيح أو للوصول إلى إجابة مرتبطة بالمحتوى المتاح.

4. قيّم المقال بعد قراءته
تحتوي صفحات المقالات على أداة لإرسال تقييم وملاحظات على المقال. استخدمها لتوضيح ما إذا كان المحتوى مفيدًا أو يحتاج إلى تحسين.

5. ارجع إلى مركز المساعدة عند الحاجة
بعد قراءة المقال يمكنك العودة إلى مركز المساعدة ومتابعة تصفح محتوى الدعم المنشور.

مهم: هذا الدليل يشرح فقط الوظائف الظاهرة والمؤكدة داخل مركز المساعدة في TCRM.$ar$,
    $en$The TCRM Help Center is the area used to access published support content inside the system.

1. Open the Help Center
Open the Help Center from inside TCRM. The route used by the application is /app/help.

2. Open the relevant help article
From the Help Center home page, you can navigate to published help articles and open the article that covers the topic you need. Each article has its own page for reading the content.

3. Use the AI support assistant
The Help Center includes an AI support assistant that helps you understand available information. Its responses are grounded in published Help Center knowledge-base content, so use it to ask for clarification or guidance based on that content.

4. Send article feedback
Article pages include a feedback control. Use it to indicate whether the content was useful or needs improvement.

5. Return to the Help Center when needed
After reading an article, you can return to the Help Center and continue browsing published support content.

Important: this guide documents only behavior confirmed in the TCRM Help Center implementation.$en$,
    'published',
    81,
    'مركز المساعدة في TCRM - دليل الاستخدام',
    'TCRM Help Center - Usage Guide',
    'دليل استخدام مركز المساعدة ومقالات الدعم والمساعد الذكي وتقييم المقالات.',
    'Guide to the TCRM Help Center, support articles, AI assistance, and article feedback.',
    NOW(),
    'general',
    false,
    NULL,
    '[]'::jsonb
  )
  ON CONFLICT (tenant_id, slug) DO UPDATE SET
    module_id = EXCLUDED.module_id,
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    title_ar = EXCLUDED.title_ar,
    title_en = EXCLUDED.title_en,
    excerpt_ar = EXCLUDED.excerpt_ar,
    excerpt_en = EXCLUDED.excerpt_en,
    body_ar = EXCLUDED.body_ar,
    body_en = EXCLUDED.body_en,
    status = EXCLUDED.status,
    sort_order = EXCLUDED.sort_order,
    seo_title_ar = EXCLUDED.seo_title_ar,
    seo_title_en = EXCLUDED.seo_title_en,
    seo_description_ar = EXCLUDED.seo_description_ar,
    seo_description_en = EXCLUDED.seo_description_en,
    published_at = COALESCE(kb_articles.published_at, NOW()),
    visibility_scope = 'general',
    consumer_hidden = false,
    canonical_article_id = NULL,
    media = '[]'::jsonb,
    updated_at = NOW();
END $$;

COMMIT;
