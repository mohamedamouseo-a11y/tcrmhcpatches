-- TCRMHC Phase 13: Wadie Optimization & Learning V13.0
-- Grounded in confirmed TCRM Wadie UI/services:
-- Optimization Review Center, Recommendation Effectiveness,
-- Approved Learning Registry, and Human-curated Playbooks.

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
    RAISE EXCEPTION 'TCRMHC_PHASE13_REQUIRES_TCRM_MODULE';
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
    RAISE EXCEPTION 'TCRMHC_PHASE13_REQUIRES_AI_STAFF_CATEGORY';
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
    RAISE EXCEPTION 'TCRMHC_PHASE13_REQUIRES_AI_STAFF_OPS_SUBCATEGORY';
  END IF;

  INSERT INTO kb_articles (
    tenant_id,module_id,category_id,subcategory_id,slug,title_ar,title_en,excerpt_ar,excerpt_en,
    body_ar,body_en,status,sort_order,seo_title_ar,seo_title_en,seo_description_ar,seo_description_en,
    published_at,visibility_scope,consumer_hidden,canonical_article_id,media
  ) VALUES
  (
    owner_tenant,v_module_id,v_category_id,v_subcategory_id,'tcrm-ai-staff-wadie',
    'استخدام Wadie في TCRM','Using Wadie in TCRM',
    'تعرّف على وظائف Wadie المؤكدة في مراجعة التحسين وقياس فعالية التوصيات وتنظيم التعلم المعتمد وPlaybooks البشرية.',
    'Learn the confirmed Wadie capabilities for optimization review, recommendation effectiveness, approved learning, and human-curated playbooks.',
    $ar$Wadie هو موظف ذكاء اصطناعي متخصص داخل TCRM لدعم قرارات تحسين الحملات مع إبقاء القرار والتنفيذ تحت مراجعة بشرية.

الوظائف المؤكدة حاليًا تشمل:
• Optimization Review Center لمراجعة توصيات التحسين قبل تحويلها إلى قائمة التنفيذ.
• Recommendation Effectiveness لقياس نتائج التوصيات بعد المراجعة البشرية.
• Approved Learning Registry لعرض مرشحات التعلم التي تم اعتمادها بشريًا فقط.
• Human-curated Playbooks لتحويل العناصر المعتمدة إلى مسودات Playbook يكتبها ويراجعها المستخدم.

مهم: هذه الأدوات لا تعني تنفيذًا تلقائيًا أو تعلمًا ذاتيًا غير خاضع للمراجعة. التنفيذ يظل منفصلًا ومقيدًا بآليات الاعتماد الموجودة في النظام.$ar$,
    $en$Wadie is a specialized AI Staff member in TCRM that supports campaign optimization decisions while keeping review and execution under human control.

Confirmed capabilities currently include:
• Optimization Review Center for reviewing optimization recommendations before execution-queue handoff.
• Recommendation Effectiveness for measuring recommendation outcomes after human review.
• Approved Learning Registry for displaying only learning candidates that were explicitly approved by a human.
• Human-curated Playbooks for turning approved registry items into playbook drafts authored and reviewed by users.

Important: these tools do not mean unrestricted automatic execution or autonomous learning. Execution remains separate and governed by the platform approval controls.$en$,
    'published',70,
    'استخدام Wadie في TCRM','Using Wadie in TCRM',
    'دليل وظائف Wadie في المراجعة والتحليلات والتعلم المعتمد وPlaybooks البشرية.',
    'Guide to Wadie review, analytics, approved learning, and human-curated playbooks.',
    NOW(),'general',false,NULL,'[]'::jsonb
  ),
  (
    owner_tenant,v_module_id,v_category_id,v_subcategory_id,'tcrm-wadie-optimization-review',
    'مركز مراجعة التحسين في Wadie','Wadie Optimization Review Center',
    'راجع توصيات Audit وMonitoring واعتمدها أو ارفضها قبل إرسالها إلى قائمة التنفيذ.',
    'Review Audit and Monitoring recommendations, approve or reject them, and only then hand them to the execution queue.',
    $ar$Optimization Review Center هو مساحة المراجعة البشرية لتوصيات Wadie قبل أي انتقال إلى التنفيذ.

1. إنشاء عناصر المراجعة
يمكن التقاط توصيات الـAudit الحالية أو مزامنة توصيات Monitoring لإنشاء عناصر داخل قائمة المراجعة.

2. متابعة الحالة
يعرض المركز حالات مثل Pending وApproved وQueued وRejected، ويظهر أيضًا العناصر ذات الأولوية العالية.

3. الاعتماد أو الرفض
كل توصية تمر بقرار بشري. يمكن اعتمادها أو رفضها قبل التفكير في التنفيذ.

4. الإرسال إلى Execution Queue
بعد الاعتماد يمكن تجهيز بيانات التنفيذ وإرسال العنصر إلى قائمة التنفيذ. يلزم وجود Wadie connection مطابق للحساب، كما يجب أن تحتوي بيانات التنفيذ على تغييرات فعلية وليست Account ID فقط.

5. لا يوجد تنفيذ مباشر من مركز المراجعة
المركز مسؤول عن المراجعة والـhandoff فقط. التنفيذ الفعلي يظل خاضعًا لمسار الاعتماد والضوابط المخصصة للتنفيذ.$ar$,
    $en$The Optimization Review Center is Wadie’s human-review workspace for recommendations before anything moves toward execution.

1. Create review items
Current Audit recommendations can be captured, and Monitoring recommendations can be synchronized into the review queue.

2. Track status
The center shows states such as Pending, Approved, Queued, and Rejected, and also highlights high-priority items.

3. Approve or reject
Every recommendation requires a human decision. It can be approved or rejected before execution is considered.

4. Send to the Execution Queue
After approval, execution arguments can be prepared and the item can be handed to the execution queue. A matching saved Wadie connection is required, and the execution payload must contain actual intended update fields rather than an account identifier alone.

5. No direct execution from the review center
This center performs review and queue handoff only. Actual execution remains governed by the dedicated execution approval and safety controls.$en$,
    'published',90,
    'مركز مراجعة التحسين في Wadie','Wadie Optimization Review Center',
    'شرح مراجعة واعتماد ورفض توصيات Wadie وإرسال المعتمد إلى Execution Queue.',
    'Review, approve, reject, and hand Wadie optimization recommendations to the Execution Queue.',
    NOW(),'general',false,NULL,'[]'::jsonb
  ),
  (
    owner_tenant,v_module_id,v_category_id,v_subcategory_id,'tcrm-wadie-recommendation-effectiveness',
    'تحليل فعالية توصيات Wadie','Wadie Recommendation Effectiveness',
    'اقرأ تحليلات نتائج التوصيات التي تمت مراجعتها بشريًا بدون تغيير قرارات التنفيذ تلقائيًا.',
    'Read analytics for human-reviewed recommendation outcomes without automatically changing execution decisions.',
    $ar$Recommendation Effectiveness يعرض تحليلات وصفية لنتائج توصيات Wadie بعد مراجعتها بشريًا.

المؤشرات الأساسية تشمل:
• Tracked: عدد العناصر التي تتم متابعتها.
• Reviewed: عدد النتائج التي تمت مراجعتها.
• Coverage: نسبة التغطية بالمراجعة.
• Quality Score: درجة وصفية لجودة النتائج.
• Improved Rate: نسبة الحالات التي تحسنت.

كما يمكن عرض النتائج حسب Platform وPriority وRecommendation Category، مع أعداد Improved وWorse لكل مجموعة.

هذه الشاشة للقراءة والتحليل فقط. البيانات مشتقة من النتائج المحلية التي راجعها المستخدم، ولا تقوم بتغيير منصة إعلانية أو قرار تنفيذ أو تعلم تلقائي.$ar$,
    $en$Recommendation Effectiveness provides descriptive analytics for Wadie recommendations after their outcomes have been reviewed by humans.

Core indicators include:
• Tracked: the number of items being followed.
• Reviewed: the number of reviewed outcomes.
• Coverage: review coverage percentage.
• Quality Score: a descriptive outcome-quality score.
• Improved Rate: the percentage of reviewed cases that improved.

Results can also be broken down by Platform, Priority, and Recommendation Category, including Improved and Worse counts for each group.

This screen is read-only analytics. Its data is derived from locally reviewed human outcomes and does not automatically change an ad platform, execution decision, or learning behavior.$en$,
    'published',100,
    'تحليل فعالية توصيات Wadie','Wadie Recommendation Effectiveness',
    'شرح مؤشرات Coverage وQuality Score وImproved Rate وتحليل توصيات Wadie.',
    'Guide to Coverage, Quality Score, Improved Rate, and Wadie recommendation analytics.',
    NOW(),'general',false,NULL,'[]'::jsonb
  ),
  (
    owner_tenant,v_module_id,v_category_id,v_subcategory_id,'tcrm-wadie-approved-learning-registry',
    'سجل التعلم المعتمد في Wadie','Wadie Approved Learning Registry',
    'راجع فقط مرشحات التعلم التي تم اعتمادها بشريًا قبل استخدامها في تنظيم Playbooks.',
    'Review only human-approved learning candidates before they are curated into playbooks.',
    $ar$Approved Learning Registry هو سجل للقراءة يعرض مرشحات التعلم التي اجتازت الاعتماد البشري.

1. ما الذي يظهر في السجل؟
يعرض العناصر المعتمدة فقط، ويمكن أن تكون مصنفة حسب Platform أو Priority أو Category أو Account.

2. مؤشرات كل عنصر
قد يعرض العنصر معلومات مثل Reviewed وQuality وImproved Rate وCoverage، بالإضافة إلى rationale وملاحظة الاعتماد البشري عند وجودها.

3. العنصر المعتمد ليس تعلمًا نشطًا
وجود العنصر في السجل يعني أنه تم اعتماده وتجهيزه للمرحلة التالية، لكنه لا ينشئ ذاكرة تعلم نشطة ولا يعيد استخدام توصية تلقائيًا.

4. المرحلة التالية
العناصر المعتمدة يمكن استخدامها في Human-curated Playbooks، حيث يقوم المستخدم بصياغة المحتوى والضوابط المطلوبة قبل أي إعادة استخدام لاحقة.$ar$,
    $en$The Approved Learning Registry is a read-only registry that shows learning candidates that passed explicit human approval.

1. What appears in the registry?
Only approved items are shown. Entries can be categorized by Platform, Priority, Category, or Account.

2. Entry indicators
An entry can include Reviewed count, Quality, Improved Rate, Coverage, rationale, and the human approval note when available.

3. Approved does not mean active learning
An item in this registry is approved and staged for the next step, but it does not create active learning memory or automatically reuse a recommendation.

4. Next step
Approved entries can move into Human-curated Playbooks, where users author the content and guardrails before any later reuse workflow.$en$,
    'published',110,
    'سجل التعلم المعتمد في Wadie','Wadie Approved Learning Registry',
    'شرح العناصر المعتمدة ومؤشراتها وحالتها قبل تنظيمها في Playbooks.',
    'Guide to approved Wadie learning candidates, their metrics, and their staged state before playbook curation.',
    NOW(),'general',false,NULL,'[]'::jsonb
  ),
  (
    owner_tenant,v_module_id,v_category_id,v_subcategory_id,'tcrm-wadie-human-curated-playbooks',
    'إنشاء Playbooks منظمة بشريًا في Wadie','Creating Human-curated Playbooks in Wadie',
    'حوّل عناصر التعلم المعتمدة إلى مسودات Playbook يكتبها المستخدم ويحدد هدفها وتعليماتها وضوابطها.',
    'Turn approved learning entries into playbook drafts authored by users with objectives, instructions, and guardrails.',
    $ar$Human-curated Playbooks تسمح بتحويل عناصر Approved Learning Registry إلى مسودات Playbook يكتبها الإنسان.

1. اختر العنصر المعتمد
يبدأ الـPlaybook من عنصر موجود في سجل التعلم المعتمد، وليس من تعلم تلقائي غير مراجع.

2. اكتب محتوى الـPlaybook
يمكن للمستخدم تحديد Title وObjective، وإضافة Instructions وGuardrail Notes عند الحاجة.

3. احفظ كمسودة
يمكن إبقاء العنصر في حالة Draft أثناء المراجعة والتطوير.

4. جهّزه لمراجعة إعادة الاستخدام
بعد اكتمال المحتوى يمكن تغيير الحالة إلى Ready for Reuse Review. هذه الحالة لا تعني أن الـPlaybook أصبح نشطًا أو يتم تطبيقه تلقائيًا.

5. التحكم البشري مستمر
إنشاء الـPlaybook وتنظيمه خطوة بشرية، وأي إعادة استخدام لاحقة تظل مرحلة منفصلة تخضع لضوابط ومراجعات إضافية.$ar$,
    $en$Human-curated Playbooks turn Approved Learning Registry entries into playbook drafts authored by people.

1. Start from an approved entry
A playbook begins from an item in the Approved Learning Registry, not from unreviewed autonomous learning.

2. Author the playbook
Users can define a Title and Objective and optionally add Instructions and Guardrail Notes.

3. Save as a draft
The item can remain in Draft state while it is being reviewed and refined.

4. Mark it ready for reuse review
When the content is complete, it can be marked Ready for Reuse Review. This does not mean the playbook is active or automatically applied.

5. Human control continues
Playbook creation and curation are human steps, and any later reuse remains a separate workflow governed by additional review and guardrails.$en$,
    'published',120,
    'إنشاء Playbooks منظمة بشريًا في Wadie','Creating Human-curated Playbooks in Wadie',
    'شرح كتابة وحفظ وتجهيز Playbooks البشرية في Wadie لمراجعة إعادة الاستخدام.',
    'Guide to authoring, saving, and preparing human-curated Wadie playbooks for reuse review.',
    NOW(),'general',false,NULL,'[]'::jsonb
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
      'tcrm-ai-staff-wadie',
      'tcrm-wadie-optimization-review',
      'tcrm-wadie-recommendation-effectiveness',
      'tcrm-wadie-approved-learning-registry',
      'tcrm-wadie-human-curated-playbooks'
    )
    AND status = 'published'
    AND visibility_scope = 'general'
    AND consumer_hidden = false;

  IF published_count <> 5 THEN
    RAISE EXCEPTION 'TCRMHC_PHASE13_PUBLISHED_ARTICLE_COUNT_MISMATCH: %', published_count;
  END IF;
END $$;

COMMIT;
