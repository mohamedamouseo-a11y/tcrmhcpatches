-- TCRMHC Phase 16: Shawky Social Media Operations, Postiz & Publishing V16.0
-- Grounded in current Shawky implementation from TCRM main.
-- Covers Shawky runtime, accounts/OAuth, composer, media, drafts, scheduling, calendar, guarded publishing, and access/security.

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
    RAISE EXCEPTION 'TCRMHC_PHASE16_REQUIRES_TCRM_MODULE';
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
    RAISE EXCEPTION 'TCRMHC_PHASE16_REQUIRES_AI_STAFF_CATEGORY';
  END IF;

  INSERT INTO kb_subcategories (
    tenant_id, category_id, title_ar, title_en, slug,
    description_ar, description_en, status, sort_order
  ) VALUES (
    owner_tenant,
    v_category_id,
    'Shawky - السوشيال ميديا والنشر',
    'Shawky - Social Media Operations & Publishing',
    'tcrm-shawky-social-operations',
    'دليل عملي لتشغيل Shawky لإدارة حسابات السوشيال والمحتوى والوسائط والجدولة والنشر عبر Postiz داخل TCRM.',
    'Practical guide to operating Shawky for social accounts, content, media, scheduling, and publishing through Postiz inside TCRM.',
    'active',
    77
  ) ON CONFLICT (tenant_id, slug) DO UPDATE
  SET category_id = EXCLUDED.category_id,
      title_ar = EXCLUDED.title_ar,
      title_en = EXCLUDED.title_en,
      description_ar = EXCLUDED.description_ar,
      description_en = EXCLUDED.description_en,
      status = EXCLUDED.status,
      sort_order = EXCLUDED.sort_order,
      updated_at = NOW()
  RETURNING id INTO v_subcategory_id;

  INSERT INTO kb_articles (
    tenant_id,module_id,category_id,subcategory_id,slug,title_ar,title_en,excerpt_ar,excerpt_en,
    body_ar,body_en,status,sort_order,seo_title_ar,seo_title_en,seo_description_ar,seo_description_en,
    published_at,visibility_scope,consumer_hidden,canonical_article_id,media
  ) VALUES
  (
    owner_tenant,v_module_id,v_category_id,v_subcategory_id,$s$tcrm-ai-staff-shawky$s$,
    $ar$استخدام Shawky لإدارة السوشيال ميديا والنشر من داخل TCRM$ar$,$en$Using Shawky for Social Media Operations and Publishing in TCRM$en$,
    $arx$تعرّف على Shawky كأخصائي سوشيال ميديا بالذكاء الاصطناعي يدير الحسابات والمحتوى والجدولة والنشر عبر Postiz من داخل TCRM.$arx$,$enx$Learn how Shawky works as an AI social media specialist for accounts, content, scheduling, and publishing through Postiz inside TCRM.$enx$,
    $arb$Shawky في النسخة الحالية من TCRM هو أخصائي سوشيال ميديا بالذكاء الاصطناعي، ومساحة عمله مصممة لتجميع تشغيل الحسابات والمحتوى والجدولة والنشر داخل TCRM بدل التنقل بين أدوات متعددة.

أهم ما تعرضه مساحة Shawky:
• حالة محرك Postiz وهل الاتصال متاح أم لا.
• عدد الحسابات الاجتماعية المتصلة.
• عدد المنشورات المجدولة والمنشورة والمسودات ضمن النطاق الزمني الحالي.
• Content Composer لإنشاء المحتوى واختيار الحسابات وإضافة الوسائط.
• حفظ Draft أو Schedule أو Publish Now بخطوة تأكيد صريحة.
• Content وCalendar لعرض المنشورات الحديثة والمجدولة والمنشورة.
• Accounts لعرض الحسابات المتصلة وبدء OAuth للحسابات الجديدة.

Shawky لا يعتمد على بيانات وهمية عند تعذر Postiz؛ الواجهة تعرض حالة عدم التوفر بدل اختلاق نتائج. كذلك Analytics وAI وSettings تظهر كمساحات محفوظة للتوسعات اللاحقة عندما لا يكون الربط الفعلي مكتملًا.

ابدأ دائمًا من Dashboard للتأكد أن Engine متصل، ثم انتقل إلى Accounts للتأكد من الحسابات، وبعدها استخدم Content لإنشاء المسودات أو الجدولة أو النشر.$arb$,$enb$In the current TCRM implementation, Shawky is an AI Social Media Specialist. His workspace brings account management, content creation, scheduling, and publishing into TCRM instead of forcing users to switch between separate tools.

The Shawky workspace currently exposes:
• Postiz runtime status and connectivity.
• Connected social-account counts.
• Scheduled, published, and draft counts for the active date range.
• A Content Composer for writing content, choosing accounts, and attaching media.
• Draft, Schedule, and Publish Now actions with an explicit publishing confirmation gate.
• Content and Calendar views for recent, scheduled, and published posts.
• Accounts for connected integrations and OAuth connection flows.

Shawky does not display fabricated placeholder data when Postiz cannot be read. The interface shows an unavailable or empty state instead. Analytics, AI, and Settings remain clearly marked as pending areas when their live wiring is not yet implemented.

Start on Dashboard to confirm that the engine is connected, review Accounts, and then use Content to create drafts, schedules, or immediate publishing actions.$enb$,
    'published',75,
    $arseo$استخدام Shawky لإدارة السوشيال ميديا والنشر من داخل TCRM$arseo$,$enseo$Using Shawky for Social Media Operations and Publishing in TCRM$enseo$,
    $ardesc$تعرّف على Shawky كأخصائي سوشيال ميديا يدير الحسابات والمحتوى والجدولة والنشر عبر Postiz داخل TCRM.$ardesc$,$endesc$Learn how Shawky manages social accounts, content, scheduling, and publishing through Postiz inside TCRM.$enddesc$,
    NOW(),'general',false,NULL,'[]'::jsonb
  ),
  (
    owner_tenant,v_module_id,v_category_id,v_subcategory_id,$s$tcrm-shawky-dashboard-runtime$s$,
    $ar$فهم Dashboard وحالة Postiz في Shawky$ar$,$en$Understanding Shawky Dashboard and Postiz Runtime Status$en$,
    $arx$راجع حالة المحرك والحسابات والمنشورات المجدولة والمنشورة والمسودات، واعرف متى تكون بيانات Shawky متاحة فعليًا.$arx$,$enx$Review engine health, connected accounts, scheduled and published posts, drafts, and when Shawky data is genuinely available.$enx$,
    $arb$Dashboard في Shawky تبدأ بفحص Health لمحرك Postiz، ويتم تحديث حالة الاتصال دوريًا ويمكن للمستخدم تنفيذ Refresh data يدويًا.

المؤشرات الأساسية الحالية هي:
• Connected Accounts: عدد الحسابات غير المتوقفة.
• Scheduled Posts: العناصر التي حالتها scheduled أو schedule أو queued.
• Published: العناصر التي حالتها published أو publish أو posted.
• Drafts: العناصر التي حالتها draft أو drafts.
• Engine: Connected أو Unavailable حسب فحص Postiz.

الواجهة تستخدم افتراضيًا نطاقًا زمنيًا لآخر 30 يومًا لقراءة المنشورات والملخص، بينما الـbackend يرفض أي نطاق يتجاوز 93 يومًا.

إذا كان Postiz غير متاح، لا يعرض النظام أرقامًا مخترعة. ستظهر حالة Unavailable أو Empty State. استخدم Refresh data بعد إصلاح الخدمة أو إعداد API ثم أعد مراجعة المؤشرات.

مؤشر Engagement ومساحة Analytics ما زالا Pending في التنفيذ الحالي، لذلك لا تتعامل معهما على أنهما مصدر تحليلات مكتمل.$arb$,$enb$Shawky Dashboard starts by checking the Postiz runtime health. Connectivity is refreshed periodically and can also be rechecked through Refresh data.

Current live metrics include:
• Connected Accounts: integrations that are not disabled.
• Scheduled Posts: items normalized as scheduled, schedule, or queued.
• Published: items normalized as published, publish, or posted.
• Drafts: items normalized as draft or drafts.
• Engine: Connected or Unavailable based on the Postiz health check.

The UI reads the previous 30 days by default for post and summary data, while backend date-range validation rejects ranges longer than 93 days.

When Postiz is unavailable, the system does not invent values. It renders an unavailable or empty state. After fixing the runtime or API setup, use Refresh data and review the metrics again.

Engagement and the Analytics workspace are still pending in the current implementation, so they should not be treated as completed analytics sources.$enb$,
    'published',85,
    $arseo$فهم Dashboard وحالة Postiz في Shawky$arseo$,$enseo$Understanding Shawky Dashboard and Postiz Runtime Status$enseo$,
    $ardesc$راجع صحة Postiz والحسابات والمنشورات والمسودات وحدود النطاق الزمني في Dashboard Shawky.$ardesc$,$enddesc$Review Postiz health, account/post/draft metrics, and date-range behavior in the Shawky Dashboard.$enddesc$,
    NOW(),'general',false,NULL,'[]'::jsonb
  ),
  (
    owner_tenant,v_module_id,v_category_id,v_subcategory_id,$s$tcrm-shawky-accounts-oauth$s$,
    $ar$ربط حسابات السوشيال في Shawky باستخدام OAuth$ar$,$en$Connecting Social Accounts in Shawky with OAuth$en$,
    $arx$اعرض الحسابات المتصلة وابدأ OAuth للحسابات المدعومة، وافهم خطوات اختيار حساب Meta وحالات Setup Required.$arx$,$enx$View connected accounts, start OAuth for supported providers, and understand Meta account selection and Setup Required states.$enx$,
    $arb$تبويب Accounts يعرض حسابات Postiz المتصلة مع الاسم والصورة والحالة، ويبيّن الحساب Connected أو Disabled.

Shawky يتعامل مع مجموعة مزودين اجتماعيين يدعمها الـbackend مثل Facebook وInstagram وLinkedIn وTikTok وX وYouTube، مع Variants داخلية لبعض المزودين. لكن زر Connect لا يظهر كجاهز إلا إذا كان المزود موجودًا في إعداد SHAWKY_OAUTH_PROVIDERS على الخادم.

عند الضغط على Connect يبدأ OAuth من Postiz. بعد العودة إلى TCRM يمكن أن تكون النتيجة:
• success: تم الربط ويعاد تحميل Accounts.
• selection_required: يجب اختيار Page أو Account محدد قبل إكمال الربط، ويظهر الاختيار داخل تبويب Accounts.
• setup_required: توجد إعدادات إضافية مطلوبة.
• error: فشل الربط.

في تدفق Meta قد يعيد Postiz عدة حسابات/صفحات للاختيار. اختر العنصر الصحيح من القائمة؛ اختيار OAuth مؤقت ويمكن أن تنتهي صلاحيته، وعندها ابدأ Connect من جديد.

لا تحاول إضافة Provider غير مهيأ من الواجهة، ولا تضع أسرار OAuth داخل المتصفح. الإعداد الفعلي للمزود يتم على الخادم.$arb$,$enb$The Accounts tab displays Postiz integrations with account name, picture, and state, including Connected or Disabled.

The backend supports social-provider identifiers such as Facebook, Instagram, LinkedIn, TikTok, X, and YouTube, including internal variants for some providers. A provider is considered ready to connect only when it is present in the server-side SHAWKY_OAUTH_PROVIDERS configuration.

Selecting Connect starts the Postiz OAuth flow. When the user returns to TCRM, the result can be:
• success: the account is connected and account data is refreshed.
• selection_required: a specific Page or account must be chosen before connection is completed, and the selection appears inside Accounts.
• setup_required: additional provider configuration is required.
• error: the connection failed.

For Meta, Postiz can return multiple Pages/accounts. Choose the correct option. OAuth selections are temporary and can expire; if that happens, start Connect again.

Do not try to expose provider secrets in the browser. Provider setup and credentials belong on the server.$enb$,
    'published',95,
    $arseo$ربط حسابات السوشيال في Shawky باستخدام OAuth$arseo$,$enseo$Connecting Social Accounts in Shawky with OAuth$enseo$,
    $ardesc$اربط Facebook وInstagram وLinkedIn وTikTok وX وYouTube عبر OAuth المهيأ على الخادم وتعامل مع اختيار حساب Meta.$ardesc$,$enddesc$Connect configured Facebook, Instagram, LinkedIn, TikTok, X, and YouTube providers and handle Meta account selection.$enddesc$,
    NOW(),'general',false,NULL,'[]'::jsonb
  ),
  (
    owner_tenant,v_module_id,v_category_id,v_subcategory_id,$s$tcrm-shawky-content-composer$s$,
    $ar$إنشاء محتوى واختيار الحسابات في Shawky Content Composer$ar$,$en$Creating Content and Selecting Accounts in Shawky Content Composer$en$,
    $arx$اكتب المحتوى أو أضف وسائط، اختر الحسابات الصحيحة، ثم احفظ Draft أو جدول المنشور أو جهزه للنشر الفوري.$arx$,$enx$Write content or attach media, choose the correct accounts, then save a draft, schedule the post, or prepare immediate publishing.$enx$,
    $arb$Content Composer هو مساحة إنشاء المنشور داخل Shawky. قبل أي إجراء يجب أن يحتوي المنشور على نص أو Media على الأقل، ويجب اختيار حساب اجتماعي واحد على الأقل.

القيود الحالية في الـbackend:
• النص حتى 5000 حرف.
• من 1 إلى 12 حسابًا اجتماعيًا، بدون تكرار Integration ID.
• بحد أقصى 10 عناصر Media.

الحسابات المتاحة للاختيار هي الحسابات المتصلة وغير Disabled. بعد كتابة المحتوى واختيار الحسابات يمكنك استخدام:
• Save Draft لحفظ مسودة.
• Schedule لتحديد موعد مستقبلي.
• Publish Now لبدء عملية نشر فوري محمية بخطوة تأكيد.

يمكن أن يكون النص فارغًا إذا كان المنشور يحتوي على Media صالحة. بعد نجاح Draft أو Schedule أو Publish يتم تفريغ النص والوسائط وتحديث قائمة المنشورات والملخص.

إذا لم توجد حسابات متصلة، سيعرض Composer رسالة واضحة ولن يسمح بالتنفيذ حتى يتم ربط حساب صالح.$arb$,$enb$The Content Composer is Shawky’s in-TCRM post creation workspace. Before any action, the post must contain text or at least one valid media item, and at least one social account must be selected.

Current backend limits are:
• Up to 5,000 text characters.
• Between 1 and 12 social integrations, with duplicate integration IDs rejected.
• Up to 10 media items.

Only connected, non-disabled accounts are available for selection. After preparing content and accounts, the user can:
• Save Draft.
• Schedule for a future time.
• Publish Now through a protected confirmation flow.

Text can be empty when valid media is present. After a successful draft, schedule, or publish action, the composer clears its content/media state and refreshes posts and summary data.

If no accounts are connected, the composer shows a clear empty state and execution remains unavailable until a valid account is connected.$enb$,
    'published',105,
    $arseo$إنشاء محتوى واختيار الحسابات في Shawky Content Composer$arseo$,$enseo$Creating Content and Selecting Accounts in Shawky Content Composer$enseo$,
    $ardesc$تعرّف على شروط النص والحسابات والوسائط قبل حفظ المسودة أو الجدولة أو النشر في Shawky.$ardesc$,$enddesc$Understand content, account, and media requirements before drafting, scheduling, or publishing with Shawky.$enddesc$,
    NOW(),'general',false,NULL,'[]'::jsonb
  ),
  (
    owner_tenant,v_module_id,v_category_id,v_subcategory_id,$s$tcrm-shawky-media-upload$s$,
    $ar$رفع الصور والفيديو بأمان في Shawky$ar$,$en$Uploading Images and Video Safely in Shawky$en$,
    $arx$اعرف أنواع الوسائط والأحجام المسموح بها وكيف يتحقق TCRM من Upload Postiz قبل استخدامها في المنشور.$arx$,$enx$Learn supported media types and size limits and how TCRM validates Postiz uploads before a post can use them.$enx$,
    $arb$Shawky يسمح بإضافة Media إلى المنشور من Content Composer ثم يرسل الرفع عبر Route محمي في TCRM إلى Postiz.

القيود في الواجهة:
• الصور: JPEG وPNG وGIF وWebP وAVIF وBMP وTIFF حتى 10 MB للصورة.
• الفيديو: MP4 فقط حتى 1 GB.
• الحد الأقصى 10 عناصر Media للمنشور.

Route الرفع `/api/shawky/media/upload` يتطلب مستخدم Admin، ويتحقق من Same Origin ومن أن الطلب multipart/form-data. مفتاح Postiz يبقى على الخادم ولا يتم إرساله إلى المتصفح.

بعد نجاح Postiz لا يقبل TCRM أي URL عشوائي. يتم التحقق أن Media URL يستخدم HTTPS وأن Origin يطابق SHAWKY_PUBLIC_ORIGIN وأن المسار يطابق شكل Upload المسموح. كذلك عند قراءة الملفات من `/uploads` يتم السماح بأنواع Content-Type معروفة وإضافة حماية nosniff.

إذا رفض النظام الملف، راجع النوع والحجم أولًا. وإذا كان الرفع نفسه غير مهيأ، راجع إعداد Postiz وSHAWKY_PUBLIC_ORIGIN على الخادم بدل محاولة استخدام رابط خارجي يدويًا.$arb$,$enb$Shawky can attach media from the Content Composer. TCRM proxies the upload through a protected route to Postiz.

Client-side limits are:
• Images: JPEG, PNG, GIF, WebP, AVIF, BMP, and TIFF, up to 10 MB per image.
• Video: MP4 only, up to 1 GB.
• A maximum of 10 media items per post.

The `/api/shawky/media/upload` route requires an Admin user, enforces same-origin requests, and expects multipart/form-data. The Postiz API key stays on the server and is never sent to the browser.

After Postiz uploads a file, TCRM does not accept arbitrary URLs. It verifies HTTPS, requires the origin to match SHAWKY_PUBLIC_ORIGIN, and checks the expected upload-path format. Proxied `/uploads` responses also restrict content types and add nosniff protection.

If a file is rejected, check its type and size first. If upload integration is not configured, fix the server-side Postiz and SHAWKY_PUBLIC_ORIGIN settings instead of manually pasting an external URL.$enb$,
    'published',115,
    $arseo$رفع الصور والفيديو بأمان في Shawky$arseo$,$enseo$Uploading Images and Video Safely in Shawky$enseo$,
    $ardesc$اعرف صيغ الصور وMP4 وحدود الحجم والتحقق من HTTPS وOrigin في رفع Media عبر Shawky.$ardesc$,$enddesc$Understand image/MP4 limits and HTTPS/origin validation in Shawky media uploads.$enddesc$,
    NOW(),'general',false,NULL,'[]'::jsonb
  ),
  (
    owner_tenant,v_module_id,v_category_id,v_subcategory_id,$s$tcrm-shawky-drafts-scheduling$s$,
    $ar$حفظ المسودات وجدولة المنشورات في Shawky$ar$,$en$Saving Drafts and Scheduling Posts in Shawky$en$,
    $arx$استخدم Save Draft أو Schedule مع الحسابات المتصلة والوسائط الصحيحة، وحدد موعدًا مستقبليًا صالحًا للجدولة.$arx$,$enx$Use Save Draft or Schedule with connected accounts and valid media, and choose a valid future time for scheduled publishing.$enx$,
    $arb$بعد تجهيز المحتوى في Composer يمكنك اختيار Save Draft أو Schedule.

Save Draft يرسل المحتوى والحسابات والوسائط إلى Postiz بوضع draft. المسودة ستظهر لاحقًا ضمن بيانات Content عندما يعيد Postiz حالتها كـdraft أو drafts.

Schedule يتطلب تاريخًا ووقتًا صالحين في المستقبل. الواجهة تضع قيمة ابتدائية تقريبية بعد ساعة من الوقت الحالي لتسهيل البدء، لكن يجب مراجعتها قبل الحفظ. إذا كان الوقت غير صالح أو في الماضي فلن تُرسل العملية.

الـbackend يتحقق مرة أخرى من المحتوى والحسابات والوسائط، ويتأكد أن الحسابات المحددة موجودة وغير Disabled قبل إنشاء المنشور.

بعد نجاح العملية يتم تحديث Posts وSummary. راجع Calendar للتأكد من ظهور العنصر المجدول وحالته وتاريخه، ولا تعتمد فقط على رسالة النجاح في Composer.$arb$,$enb$After preparing the Content Composer, use Save Draft or Schedule.

Save Draft sends content, account integrations, and media to Postiz in draft mode. The draft can later appear in Content when Postiz reports a draft/drafts status.

Schedule requires a valid future date and time. The UI provides an initial value roughly one hour ahead for convenience, but it should be reviewed before submission. Invalid or past times are rejected before the scheduling action is sent.

The backend validates content, accounts, and media again and confirms that selected integrations exist and are not disabled before creating the post.

After success, Posts and Summary are refreshed. Check Calendar to verify the scheduled item, its state, and its timestamp instead of relying only on the composer success notification.$enb$,
    'published',125,
    $arseo$حفظ المسودات وجدولة المنشورات في Shawky$arseo$,$enseo$Saving Drafts and Scheduling Posts in Shawky$enseo$,
    $ardesc$احفظ Draft أو Schedule وتأكد من الموعد المستقبلي والحسابات والوسائط ثم راجع Calendar.$ardesc$,$enddesc$Save drafts or schedule posts with a future time, valid accounts/media, and verify the result in Calendar.$enddesc$,
    NOW(),'general',false,NULL,'[]'::jsonb
  ),
  (
    owner_tenant,v_module_id,v_category_id,v_subcategory_id,$s$tcrm-shawky-content-calendar$s$,
    $ar$قراءة Content وCalendar وحالات المنشورات في Shawky$ar$,$en$Reading Shawky Content, Calendar, and Post Statuses$en$,
    $arx$افهم كيف يعرض Shawky منشورات Postiz الحديثة وكيف يجمع الحالات المجدولة والمنشورة والمسودات داخل TCRM.$arx$,$enx$Understand how Shawky displays recent Postiz posts and normalizes scheduled, published, and draft states inside TCRM.$enx$,
    $arb$تبويب Content يعرض المنشورات التي يعيدها Postiz للنطاق الزمني الحالي، مع Status وProvider والاسم أو نص المنشور والتاريخ. إذا لم توجد بيانات سيظهر Empty State بدل بيانات تجريبية.

Shawky يوحّد عدة أسماء للحالات القادمة من Postiz:
• Scheduled يشمل scheduled وschedule وqueued.
• Published يشمل published وpublish وposted.
• Draft يشمل draft وdrafts.

تبويب Calendar يركز على العناصر المجدولة أو المنشورة ويعرض الوقت والحالة والقناة. لذلك قد تظهر عناصر في Content ولا تظهر في Calendar إذا كانت Draft مثلًا.

الـSummary يستخدم نفس التصنيف لحساب المؤشرات في Dashboard، ولذلك يجب قراءة حالة المنشور مع مصدره وتاريخه عند مراجعة أي فرق في الأعداد.

النطاق الافتراضي في الواجهة 30 يومًا، والـbackend يمنع النطاقات الأكبر من 93 يومًا. إذا كنت تبحث عن منشور قديم خارج النطاق فلن يظهر في القائمة الحالية.$arb$,$enb$The Content tab displays posts returned by Postiz for the active date range, including normalized status, provider, title/content preview, and date. When no data is returned, Shawky renders an empty state rather than demo data.

Shawky groups several Postiz status names:
• Scheduled includes scheduled, schedule, and queued.
• Published includes published, publish, and posted.
• Draft includes draft and drafts.

Calendar focuses on scheduled or published items and shows time, state, and provider. A post can therefore appear in Content but not Calendar when it is still a draft.

Dashboard Summary uses the same status groups for its counters, so review each post’s status, source, and date when investigating count differences.

The UI defaults to a 30-day range, while the backend rejects ranges longer than 93 days. Older posts outside the active range will not appear in the current list.$enb$,
    'published',135,
    $arseo$قراءة Content وCalendar وحالات المنشورات في Shawky$arseo$,$enseo$Reading Shawky Content, Calendar, and Post Statuses$enseo$,
    $ardesc$افهم حالات Scheduled وPublished وDraft وكيف تظهر في Content وCalendar وDashboard Shawky.$ardesc$,$enddesc$Understand Scheduled, Published, and Draft states across Shawky Content, Calendar, and Dashboard.$enddesc$,
    NOW(),'general',false,NULL,'[]'::jsonb
  ),
  (
    owner_tenant,v_module_id,v_category_id,v_subcategory_id,$s$tcrm-shawky-publish-now-confirmation$s$,
    $ar$النشر الفوري في Shawky وخطوة التأكيد الآمنة$ar$,$en$Immediate Publishing in Shawky and the Safe Confirmation Gate$en$,
    $arx$افهم لماذا يتطلب Publish Now تأكيدًا منفصلًا وكيف يمنع Shawky إعادة استخدام نفس الموافقة أو تكرار النشر بالخطأ.$arx$,$enx$Understand why Publish Now requires a separate confirmation and how Shawky prevents approval reuse or accidental duplicate publishing.$enx$,
    $arb$Publish Now ليس إرسالًا مباشرًا من أول ضغطة. Shawky ينفذ مرحلتين:

1. Prepare Publish: يتحقق من المحتوى والحسابات والوسائط ثم ينشئ Confirmation مؤقتة ويعرض للمستخدم أسماء الحسابات وعدد الوسائط ومعاينة المحتوى.
2. Confirm & Publish: بعد موافقة المستخدم يرسل confirmationId مع القيمة الصريحة PUBLISH_NOW.

الموافقة مرتبطة بالمستخدم الذي أنشأها، وتنتهي بعد 10 دقائق. كما يتم استهلاكها وحذفها قبل إرسال طلب النشر الخارجي إلى Postiz. لذلك لا يمكن استخدام نفس confirmationId مرتين، وحتى لو حدث Timeout وكانت نتيجة الطلب الخارجي غير معروفة لا يتم السماح بإعادة نفس الموافقة بما قد يسبب منشورًا مكررًا.

إذا ظهرت رسالة أن Confirmation انتهت أو استُخدمت، ابدأ Publish Now من جديد وراجع الحسابات والمحتوى قبل التأكيد.

نافذة التأكيد توضح أن الإجراء يسلم المنشور إلى Postiz للنشر الفوري، لذلك تأكد من الحسابات والوسائط والنص قبل الضغط على Confirm & Publish.$arb$,$enb$Publish Now is not sent on the first click. Shawky uses a two-step flow:

1. Prepare Publish validates content, accounts, and media, creates a temporary confirmation, and presents account names, media count, and a content preview.
2. Confirm & Publish sends the confirmationId together with the explicit `PUBLISH_NOW` confirmation value.

The approval is bound to the user who created it and expires after 10 minutes. It is consumed and deleted before the outbound Postiz publish request. The same confirmationId therefore cannot be reused, and an uncertain network timeout cannot be retried with the same approval in a way that could accidentally duplicate a post.

If Shawky reports that the confirmation expired or was already used, start Publish Now again and review the content/accounts before confirming.

The confirmation dialog makes clear that the action hands the post to Postiz for immediate publishing. Verify accounts, media, and text before selecting Confirm & Publish.$enb$,
    'published',145,
    $arseo$النشر الفوري في Shawky وخطوة التأكيد الآمنة$arseo$,$enseo$Immediate Publishing in Shawky and the Safe Confirmation Gate$enseo$,
    $ardesc$اعرف آلية Prepare Publish وConfirm & Publish وصلاحية الموافقة لمدة 10 دقائق ومنع إعادة استخدامها.$ardesc$,$enddesc$Learn the two-step Publish Now flow, 10-minute confirmation lifetime, and approval reuse protection.$enddesc$,
    NOW(),'general',false,NULL,'[]'::jsonb
  ),
  (
    owner_tenant,v_module_id,v_category_id,v_subcategory_id,$s$tcrm-shawky-access-security$s$,
    $ar$صلاحيات Shawky وأمان تكامل Postiz والوسائط$ar$,$en$Shawky Permissions and Postiz/Media Integration Security$en$,
    $arx$تعرّف على صلاحية Admin وقيود Loopback ومفاتيح Postiz على الخادم والتحقق من OAuth والوسائط والنطاقات الزمنية.$arx$,$enx$Learn Shawky Admin access, loopback restrictions, server-side Postiz credentials, OAuth/media validation, and date-range safeguards.$enx$,
    $arb$الـRouter الرئيسي لـShawky محمي بصلاحية Admin. أي مستخدم بدور آخر يحصل على Forbidden ولا يمكنه استخدام Queries أو Mutations الخاصة بـShawky. Route رفع الوسائط يطبق التحقق من Admin بشكل مستقل أيضًا.

إعدادات التكامل الحساسة تبقى على الخادم:
• SHAWKY_POSTIZ_URL يجب أن يشير إلى Loopback مثل 127.0.0.1 أو localhost بدون Username/Password في URL.
• SHAWKY_POSTIZ_API_KEY يبقى Server-side.
• SHAWKY_OAUTH_PROVIDERS يحدد المزودين المسموح ببدء OAuth لهم.
• SHAWKY_PUBLIC_ORIGIN يجب أن يكون HTTPS نظيفًا ويستخدم للتحقق من روابط الوسائط.

API Postiz يطبق Timeout للطلبات، ويرفض نطاق تاريخ غير صالح أو أكبر من 93 يومًا. الحسابات المختارة للمحتوى يعاد التحقق منها على الخادم ويجب أن تكون موجودة وغير Disabled.

رفع Media يطلب Same Origin وmultipart/form-data ويقيد الحجم، ثم يتحقق من URL النهائي قبل استخدامه. النشر الفوري يضيف Confirmation مؤقتة مرتبطة بالمستخدم بدل تنفيذ Publish غير مشروط.

لا تنقل API Keys إلى الواجهة ولا تغيّر Postiz runtime ليصبح مكشوفًا للعامة كحل سريع. أصل التصميم الحالي هو إبقاء التشغيل الحساس خلف TCRM والخادم.$arb$,$enb$The main Shawky router is Admin-only. Users with any other role receive a Forbidden response and cannot call Shawky queries or mutations. The media upload route independently enforces Admin authentication as well.

Sensitive integration configuration remains server-side:
• SHAWKY_POSTIZ_URL must resolve to loopback such as 127.0.0.1 or localhost, with no username/password embedded in the URL.
• SHAWKY_POSTIZ_API_KEY remains server-side.
• SHAWKY_OAUTH_PROVIDERS controls which providers can start OAuth.
• SHAWKY_PUBLIC_ORIGIN must be a clean HTTPS origin and is used to validate media URLs.

Postiz API calls use request timeouts, and invalid date ranges or ranges longer than 93 days are rejected. Selected content integrations are revalidated on the server and must exist and not be disabled.

Media upload requires same-origin multipart/form-data, enforces size controls, and validates the final URL before use. Immediate publishing adds a user-bound temporary confirmation instead of unconditional publishing.

Do not move API keys into the browser or expose the Postiz runtime publicly as a shortcut. The current design intentionally keeps sensitive operations behind TCRM and the server.$enb$,
    'published',155,
    $arseo$صلاحيات Shawky وأمان تكامل Postiz والوسائط$arseo$,$enseo$Shawky Permissions and Postiz/Media Integration Security$enseo$,
    $ardesc$اعرف حماية Admin وLoopback ومفاتيح Postiz وOAuth وHTTPS Media وحدود التاريخ في Shawky.$ardesc$,$enddesc$Understand Shawky Admin controls, loopback Postiz, server-side credentials, OAuth/media validation, and date safeguards.$enddesc$,
    NOW(),'general',false,NULL,'[]'::jsonb
  )
  ON CONFLICT (tenant_id, slug) DO UPDATE
  SET module_id = EXCLUDED.module_id,
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
      media = EXCLUDED.media,
      updated_at = NOW();

  SELECT count(*)::INTEGER
  INTO published_count
  FROM kb_articles
  WHERE tenant_id = owner_tenant
    AND slug IN (
      'tcrm-ai-staff-shawky',
      'tcrm-shawky-dashboard-runtime',
      'tcrm-shawky-accounts-oauth',
      'tcrm-shawky-content-composer',
      'tcrm-shawky-media-upload',
      'tcrm-shawky-drafts-scheduling',
      'tcrm-shawky-content-calendar',
      'tcrm-shawky-publish-now-confirmation',
      'tcrm-shawky-access-security'
    )
    AND status = 'published'
    AND visibility_scope = 'general'
    AND consumer_hidden = false
    AND length(trim(title_ar)) > 0
    AND length(trim(title_en)) > 0
    AND length(trim(body_ar)) > 0
    AND length(trim(body_en)) > 0;

  IF published_count <> 9 THEN
    RAISE EXCEPTION 'TCRMHC_PHASE16_CONTENT_VERIFY_FAILED expected=9 actual=%', published_count;
  END IF;
END $$;

COMMIT;
