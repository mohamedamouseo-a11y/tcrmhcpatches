-- TCRMHC Phase 12: Darwish Operations V12.0
-- Grounded in current TCRM implementation:
-- - Darwish AI provider gateway configuration in Admin Settings
-- - Deterministic WhatsApp group linking inside Client Profile

BEGIN;

DO $$
DECLARE
  owner_tenant UUID;
  v_module_id UUID;
  v_category_id UUID;
  v_subcategory_id UUID;
  published_count INTEGER;
BEGIN
  SELECT id, tenant_id
  INTO v_module_id, owner_tenant
  FROM kb_modules
  WHERE slug = 'tcrm'
    AND status = 'active'
  ORDER BY created_at, id
  LIMIT 1;

  IF v_module_id IS NULL OR owner_tenant IS NULL THEN
    RAISE EXCEPTION 'TCRMHC_PHASE12_REQUIRES_TCRM_MODULE';
  END IF;

  SELECT id
  INTO v_category_id
  FROM kb_categories
  WHERE tenant_id = owner_tenant
    AND module_id = v_module_id
    AND slug = 'tcrm-ai-staff'
    AND status = 'active'
  ORDER BY created_at, id
  LIMIT 1;

  IF v_category_id IS NULL THEN
    RAISE EXCEPTION 'TCRMHC_PHASE12_REQUIRES_AI_STAFF_CATEGORY';
  END IF;

  SELECT id
  INTO v_subcategory_id
  FROM kb_subcategories
  WHERE tenant_id = owner_tenant
    AND category_id = v_category_id
    AND slug = 'tcrm-ai-staff-ops'
    AND status = 'active'
  ORDER BY created_at, id
  LIMIT 1;

  IF v_subcategory_id IS NULL THEN
    RAISE EXCEPTION 'TCRMHC_PHASE12_REQUIRES_AI_STAFF_OPS_SUBCATEGORY';
  END IF;

  -- Refresh the original Darwish overview from Phase 6 so it reflects the
  -- capabilities that are now visible and confirmed in the TCRM codebase.
  INSERT INTO kb_articles (
    tenant_id,module_id,category_id,subcategory_id,slug,title_ar,title_en,excerpt_ar,excerpt_en,
    body_ar,body_en,status,sort_order,seo_title_ar,seo_title_en,seo_description_ar,seo_description_en,
    published_at,visibility_scope,consumer_hidden,canonical_article_id,media
  ) VALUES (
    owner_tenant,
    v_module_id,
    v_category_id,
    v_subcategory_id,
    'tcrm-ai-staff-darwish',
    'استخدام Darwish في TCRM',
    'Using Darwish in TCRM',
    'تعرّف على الوظائف المؤكدة حاليًا لـ Darwish في إعداد مزودي الذكاء الاصطناعي وربط مجموعات واتساب بملفات العملاء.',
    'Learn the currently confirmed Darwish capabilities for AI provider configuration and linking WhatsApp groups to client profiles.',
    $ar$Darwish هو أحد موظفي الذكاء الاصطناعي في TCRM، وتظهر له حاليًا وظيفتان تشغيليتان واضحتان داخل النظام.

1. تشغيل بوابة مزودي الذكاء الاصطناعي
من إعدادات الإدارة توجد واجهة مخصصة لإعداد مزودي الذكاء الاصطناعي المستخدمة مع Darwish. الواجهة تتعامل مع Providers وModels وRouting Policies وTargets / Fallback وتعرض حالة التشغيل والمراقبة.

2. ربط مجموعات واتساب بالعميل
داخل Client Profile يستطيع Darwish إظهار مجموعات واتساب التي تم رصدها فعليًا من التكاملات المتاحة، ثم ربط المجموعة بالعميل بشكل محدد بدل الاعتماد على إدخال JID يدوي أو تخمين الربط.

3. فصل الإعداد عن الاستخدام
إعداد Provider أو Model يتم من واجهة الإدارة، بينما ربط مجموعة واتساب يتم من ملف العميل. لذلك قد تختلف الوظائف التي تراها حسب صلاحيات حسابك ومكانك داخل النظام.

للتفاصيل استخدم المقالين المتخصصين في إعداد بوابة Darwish وربط مجموعات واتساب بالعملاء.$ar$,
    $en$Darwish is one of the AI Staff members in TCRM, with two currently visible and confirmed operational areas.

1. AI provider gateway operations
Admin Settings contains a dedicated interface for configuring the AI providers used with Darwish. The interface manages Providers, Models, Routing Policies, and Targets / Fallback and exposes runtime health and monitoring information.

2. Linking WhatsApp groups to clients
Inside Client Profile, Darwish can surface WhatsApp groups that were actually observed through the available integrations and link a group to the client deterministically instead of relying on a manually entered JID or guessed mapping.

3. Configuration and usage are separate
Provider and model configuration happens in the admin interface, while WhatsApp group linking happens from the client profile. What you can see can therefore depend on your permissions and where you are working in TCRM.

See the dedicated articles for Darwish provider gateway configuration and client WhatsApp group linking for detailed usage.$en$,
    'published',
    50,
    'استخدام Darwish في TCRM',
    'Using Darwish in TCRM',
    'شرح الوظائف المؤكدة لـ Darwish في مزودي الذكاء الاصطناعي وربط مجموعات واتساب بالعملاء.',
    'Guide to confirmed Darwish operations for AI providers and client WhatsApp group linking.',
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

  -- Article 1: Darwish AI Provider Gateway
  INSERT INTO kb_articles (
    tenant_id,module_id,category_id,subcategory_id,slug,title_ar,title_en,excerpt_ar,excerpt_en,
    body_ar,body_en,status,sort_order,seo_title_ar,seo_title_en,seo_description_ar,seo_description_en,
    published_at,visibility_scope,consumer_hidden,canonical_article_id,media
  ) VALUES (
    owner_tenant,
    v_module_id,
    v_category_id,
    v_subcategory_id,
    'tcrm-darwish-ai-provider-gateway',
    'إعداد بوابة مزودي الذكاء الاصطناعي لـ Darwish',
    'Configuring the Darwish AI Provider Gateway',
    'دليل إدارة Providers وModels وسياسات التوجيه والـ Fallback ومراقبة تشغيل Darwish.',
    'Guide to managing Providers, Models, routing policies, fallback targets, and Darwish runtime monitoring.',
    $ar$تحتوي إعدادات الإدارة في TCRM على واجهة مخصصة لإدارة بوابة مزودي الذكاء الاصطناعي الخاصة بـ Darwish.

1. راجع ملخص الإعداد
تعرض الواجهة عدد العناصر الموجودة في أربع مجموعات: Providers وModels وRouting Policies وTargets / Fallback. إذا كانت الإعدادات فارغة فلن تظهر مزودات ثابتة مفروضة من الواجهة؛ يتم إضافة ما تحتاجه من الإعدادات المتاحة.

2. أضف Provider
عند إعداد مزود جديد تحدد Provider Key وDisplay Name ونوع Adapter وBase URL وحالة التفعيل. الأنواع الظاهرة في الواجهة هي openai_compatible وchat_completions.

3. اضبط مفتاح الوصول بدون كشفه
يمكن ربط Secret بالمزود عند الحاجة. الواجهة تتعامل مع حالة وجود المفتاح ولا تعيد قيمة الـSecret نفسها كنص صريح ضمن Snapshot الإعدادات.

4. أضف Model
اربط Model بمزود محدد ثم أدخل Model Key والاسم وحالة التفعيل. يمكن أيضًا ضبط قيم مثل Temperature وMax Tokens عندما تحتاجها.

5. أنشئ Routing Policy
الواجهة تدعم مساري Darwish المؤكدين: darwish.intelligence وdarwish.reply_draft. لكل Policy يمكن اختيار استراتيجية priority أو weighted_random مع Max Attempts وTimeout.

6. أضف Targets وحدد الـFallback
كل Target يربط Policy بمزود وModel ويحتوي على Priority وWeight وحالة التفعيل وTimeout اختياري. بهذه الطريقة يمكن تكوين الترتيب أو توزيع الاختيار حسب استراتيجية الـPolicy.

7. راقب التشغيل
الواجهة تقرأ Runtime Health ومؤشرات Monitoring. المؤشرات المتاحة تشمل Calls وSuccesses وFailures وAttempts وTimeouts، مما يساعدك على معرفة ما إذا كانت البوابة تعمل بشكل سليم أو تحتاج مراجعة.

مهم: عدّل هذه الإعدادات فقط إذا كنت مسؤولًا عن إعداد Darwish، لأن تغيير Provider أو Policy أو Target يؤثر على مسار تنفيذ طلبات Darwish.$ar$,
    $en$TCRM Admin Settings contains a dedicated interface for managing the AI provider gateway used by Darwish.

1. Review the configuration summary
The interface shows counts for four groups: Providers, Models, Routing Policies, and Targets / Fallback. When configuration is empty, the UI does not force a fixed provider list; providers are configured as needed.

2. Add a Provider
A provider configuration includes Provider Key, Display Name, Adapter Type, Base URL, and enabled state. The visible adapter types are openai_compatible and chat_completions.

3. Configure access secrets without exposing them
A provider can reference a required secret when needed. The settings snapshot exposes whether required secret keys are configured but does not return the secret values in plaintext.

4. Add a Model
Link a model to a specific provider, then configure Model Key, display name, and enabled state. Optional model configuration can include Temperature and Max Tokens.

5. Create a Routing Policy
The interface exposes two confirmed Darwish route keys: darwish.intelligence and darwish.reply_draft. A policy can use either priority or weighted_random selection and includes Max Attempts and Timeout controls.

6. Add Targets and fallback behavior
Each Target links a Policy to a Provider and Model and includes Priority, Weight, enabled state, and optional Timeout. This controls ordered selection or weighted distribution according to the policy strategy.

7. Monitor runtime behavior
The interface reads runtime Health and Monitoring information. Available monitoring counters include Calls, Successes, Failures, Attempts, and Timeouts, helping administrators see whether the gateway is operating normally.

Important: change these settings only when you are responsible for Darwish configuration because Provider, Policy, and Target changes affect how Darwish requests are routed.$en$,
    'published',
    80,
    'إعداد بوابة مزودي Darwish في TCRM',
    'Darwish AI Provider Gateway Configuration in TCRM',
    'شرح إعداد Providers وModels وRouting Policies وTargets ومراقبة بوابة Darwish.',
    'Configure Providers, Models, Routing Policies, Targets, fallback, and monitoring for the Darwish gateway.',
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

  -- Article 2: Darwish Client WhatsApp Group Linking
  INSERT INTO kb_articles (
    tenant_id,module_id,category_id,subcategory_id,slug,title_ar,title_en,excerpt_ar,excerpt_en,
    body_ar,body_en,status,sort_order,seo_title_ar,seo_title_en,seo_description_ar,seo_description_en,
    published_at,visibility_scope,consumer_hidden,canonical_article_id,media
  ) VALUES (
    owner_tenant,
    v_module_id,
    v_category_id,
    v_subcategory_id,
    'tcrm-darwish-client-whatsapp-groups',
    'ربط مجموعات واتساب بالعملاء باستخدام Darwish',
    'Linking WhatsApp Groups to Clients with Darwish',
    'تعرّف على اختيار مجموعة واتساب حقيقية وربطها بملف العميل ومراجعة حالة الربط وآخر نشاط.',
    'Learn how to select a real observed WhatsApp group, link it to a client profile, and review link status and activity.',
    $ar$يحتوي Client Profile في TCRM على بطاقة لمحادثات مجموعات واتساب المرتبطة بالعميل، ويستخدم Darwish ربطًا محددًا مبنيًا على مجموعات تم رصدها فعليًا.

1. افتح ملف العميل
ادخل إلى Client Profile ثم ابحث عن بطاقة محادثات واتساب المرتبطة. البطاقة تعرض الجروبات المفعلة المرتبطة بهذا العميل فقط.

2. اضغط ربط جروب واتساب
تفتح نافذة تعرض الجروبات التي رصدها Darwish من Evolution / Chatwoot. لا يعتمد الربط على كتابة JID يدوي أو تخمين اسم العميل.

3. ابحث داخل الجروبات المتاحة
يمكن البحث باسم الجروب أو Group JID أو Evolution Instance. الجروبات غير المطابقة للبحث تختفي من القائمة مؤقتًا بدون تغيير بياناتها.

4. راجع حالة كل جروب
الجروب المتاح يمكن اختياره للربط. إذا كان الجروب مرتبطًا بعميل آخر فإنه يظهر كغير متاح ولا يتم نقله تلقائيًا إلى العميل الحالي.

5. إذا لم تجد الجروب
يجب أن يكون Darwish قد استقبل نشاطًا من الجروب أولًا حتى يظهر ضمن المرشحين المتاحين للربط.

6. راجع بيانات الجروب بعد الربط
البطاقة تعرض اسم الجروب وGroup JID وEvolution Instance، وقد تعرض Chatwoot Conversation وآخر وقت نشاط عندما تكون هذه البيانات متوفرة.

7. عزل بيانات العملاء
القائمة الخاصة بالعميل تعرض الروابط المفعلة التي تحمل Client ID نفسه فقط، ولا تُدرج جروبات عميل آخر أو الروابط المعطلة أو الجروبات غير المرتبطة.

مهم: لا تنشئ JID يدويًا بهدف إجبار الربط. استخدم الجروبات التي تم رصدها فعليًا داخل نافذة Darwish حتى يظل الربط دقيقًا.$ar$,
    $en$TCRM Client Profile contains a card for WhatsApp group conversations linked to the client, and Darwish uses deterministic mappings based on groups that were actually observed.

1. Open the client profile
Open Client Profile and locate the linked WhatsApp group conversations card. The card shows only enabled group links associated with that exact client.

2. Choose Link WhatsApp Group
The dialog lists groups observed by Darwish through Evolution / Chatwoot. Linking does not rely on manually entering a JID or guessing which group belongs to the client.

3. Search available groups
You can search by group name, Group JID, or Evolution Instance. Non-matching groups are only filtered from the visible list; their data is not changed.

4. Review group status
An eligible group can be selected for linking. A group already linked to another client remains unavailable and is not reassigned automatically.

5. If the group is missing
Darwish must first receive activity from the group before it can appear among the available linking candidates.

6. Review linked group details
After linking, the card shows the group name, Group JID, and Evolution Instance, and can also show the Chatwoot Conversation and last activity time when those values are available.

7. Client data isolation
The client card returns only enabled links whose Client ID matches the current client. Groups from another client, disabled links, and unlinked groups are excluded.

Important: do not create a manual JID to force a mapping. Use groups actually observed in the Darwish linking dialog so the mapping remains deterministic.$en$,
    'published',
    90,
    'ربط جروبات واتساب بالعملاء باستخدام Darwish',
    'Link WhatsApp Groups to Clients with Darwish',
    'شرح ربط الجروبات المرصودة فعليًا بملف العميل والبحث والحماية من الربط الخاطئ.',
    'Guide to linking actually observed WhatsApp groups to client profiles with deterministic mapping and isolation.',
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

  SELECT COUNT(*)
  INTO published_count
  FROM kb_articles
  WHERE tenant_id = owner_tenant
    AND module_id = v_module_id
    AND slug IN (
      'tcrm-ai-staff-darwish',
      'tcrm-darwish-ai-provider-gateway',
      'tcrm-darwish-client-whatsapp-groups'
    )
    AND status = 'published'
    AND visibility_scope = 'general'
    AND consumer_hidden = false;

  IF published_count <> 3 THEN
    RAISE EXCEPTION 'TCRMHC_PHASE12_EXPECTED_3_PUBLISHED_ARTICLES_GOT_%', published_count;
  END IF;
END $$;

COMMIT;
