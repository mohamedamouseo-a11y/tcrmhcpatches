-- TCRMHC Phase 15: Tara Telesales, Moderation, Social Channels & AI Providers V15.0
-- Grounded in current Tara implementation from TCRM main.
-- Covers Tara operations, qualification, knowledge, follow-ups, moderation,
-- social channels/Meta, TikTok Business Messaging, Voice/ElevenLabs, and AI providers.

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
    RAISE EXCEPTION 'TCRMHC_PHASE15_REQUIRES_TCRM_MODULE';
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
    RAISE EXCEPTION 'TCRMHC_PHASE15_REQUIRES_AI_STAFF_CATEGORY';
  END IF;

  INSERT INTO kb_subcategories (
    tenant_id, category_id, title_ar, title_en, slug,
    description_ar, description_en, status, sort_order
  ) VALUES (
    owner_tenant,
    v_category_id,
    'Tara - المبيعات والتأهيل والإشراف على المحادثات',
    'Tara - Telesales, Qualification & Conversation Moderation',
    'tcrm-tara-operations',
    'دليل عملي لتشغيل Tara في المبيعات الهاتفية والتأهيل والمتابعات والإشراف والقنوات الاجتماعية والصوت ومزودي الذكاء الاصطناعي.',
    'Practical guide to Tara telesales, qualification, follow-ups, moderation, social channels, voice, and AI-provider operations.',
    'active',
    76
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
    owner_tenant,v_module_id,v_category_id,v_subcategory_id,$s$tcrm-ai-staff-tara$s$,
    $ar$استخدام Tara للمبيعات الهاتفية وتأهيل العملاء والمحادثات$ar$,$en$Using Tara for Telesales, Lead Qualification, and Customer Conversations$en$,
    $arx$تعرّف على Tara كموظفة AI للمبيعات الهاتفية وتأهيل العملاء والمتابعة وإدارة المحادثات، وليس فقط كمصدر للـLeads.$arx$,$enx$Learn how Tara operates as an AI telesales, lead-qualification, follow-up, and conversation specialist rather than merely a lead-source label.$enx$,
    $arb$Tara في النسخة الحالية من TCRM هي أخصائية مبيعات هاتفية وتأهيل عملاء محتملين مدعومة بالذكاء الاصطناعي. مساحة Tara تجمع التشغيل والإعدادات والحملات والتأهيل والمعرفة والمتابعات والقنوات الاجتماعية والصوت ومزودي الذكاء الاصطناعي.

عند الدخول إلى Tara يتحقق النظام أولًا من صلاحية المستخدم. مستخدم Moderator يتم توجيهه إلى مساحة تشغيل منفصلة تركز على المحادثات والعمليات بدون عرض المفاتيح أو إعدادات الربط الحساسة، بينما المستخدم الإداري يصل إلى مساحة الإدارة الكاملة.

أهم مجالات العمل:
• إعداد سلوك Tara ونبرة الرد واللغات وساعات العمل.
• ربط إعداد Tara بحملات محددة.
• تعريف حقول التأهيل والأسئلة المطلوبة وربطها بحقول CRM.
• إضافة Knowledge خاصة بالشركة أو بالحملة.
• إعداد Follow-ups بمواعيد ومحاولات وقواعد توقف.
• اختبار Agent ومراجعة Logs.
• إدارة Social Channels والمحادثات والتحويل البشري.
• تشغيل Tara Voice عبر ElevenLabs بعد استكمال اختبارات التفعيل.
• اختيار مزود AI أساسي وترتيب مزودين احتياطيين.

ابدأ دائمًا من Dashboard لمراجعة النشاط، ثم اضبط Settings والحملات والتأهيل قبل الاعتماد على الردود التلقائية في المحادثات الحية.$arb$,$enb$In the current TCRM implementation, Tara is an AI-powered telesales and lead-qualification specialist. Her workspace combines operations, settings, campaigns, qualification, knowledge, follow-ups, social channels, voice, and AI-provider configuration.

When a user opens Tara, access is checked first. A Moderator is routed to a dedicated operational workspace focused on conversations and day-to-day actions without exposing secret keys or sensitive integration settings, while an administrative user can access the full management workspace.

Core areas include:
• Configuring Tara behavior, tone, languages, and business hours.
• Connecting Tara settings to specific campaigns.
• Defining qualification fields, questions, and CRM-field targets.
• Adding company-wide or campaign-scoped Knowledge.
• Configuring follow-up attempts, timing, and stop rules.
• Testing the agent and reviewing Logs.
• Managing social channels, conversations, and human handoff.
• Enabling Tara Voice through ElevenLabs after activation tests pass.
• Selecting a primary AI provider with an ordered fallback chain.

Start from the Dashboard to review activity, then configure Settings, campaigns, and qualification before relying on live automated replies.$enb$,
    'published',75,
    $arseo$استخدام Tara للمبيعات الهاتفية وتأهيل العملاء والمحادثات$arseo$,$enseo$Using Tara for Telesales, Lead Qualification, and Customer Conversations$enseo$,
    $ardesc$تعرّف على Tara كموظفة AI للمبيعات الهاتفية وتأهيل العملاء والمتابعة وإدارة المحادثات، وليس فقط كمصدر للـLeads.$ardesc$,$endesc$Learn how Tara operates as an AI telesales, lead-qualification, follow-up, and conversation specialist rather than merely a lead-source label.$endesc$,
    NOW(),'general',false,NULL,'[]'::jsonb
  ),
  (
    owner_tenant,v_module_id,v_category_id,v_subcategory_id,$s$tcrm-tara-operations$s$,
    $ar$إدارة Tara Operations والإعدادات التشغيلية$ar$,$en$Managing Tara Operations and Operational Settings$en$,
    $arx$اضبط النبرة واللغة وساعات العمل والرد التلقائي والتحويل البشري، وراجع مؤشرات التشغيل والطابور والسجلات.$arx$,$enx$Configure tone, languages, business hours, auto-send, human handoff, operational metrics, queue processing, and logs.$enx$,
    $arb$مساحة Tara Operations هي مساحة التشغيل للمستخدم Moderator. تعرض مؤشرات للحملات والمحادثات وحالة Tara والتحويل البشري وعمليات AI والأخطاء.

من الإعدادات التشغيلية يمكن التحكم في:
• تشغيل Tara أو إيقافها.
• Agent Name ووصف الدور والتعليمات العامة.
• Tone.
• Default Language واللغات المسموح بها.
• Timezone وBusiness Hours ورسالة خارج ساعات العمل.
• Reply Delay والحد الأقصى لطول الرد.
• Auto Send.
• الكلمات الافتراضية التي تؤدي إلى Handoff.

المساحة تشمل أيضًا Tabs للحملات والتأهيل والمعرفة والمتابعات والاختبار والطابور وLogs. يوجد زر لمعالجة Queue يدويًا عند الحاجة، مع عرض عدد العناصر التي تمت معالجتها.

مستخدم Moderator يعمل من هذه المساحة بدون API Keys أو إعدادات الربط التقنية الحساسة. الهدف هو الفصل بين التشغيل اليومي وبين إدارة الأسرار والبنية التقنية.$arb$,$enb$Tara Operations is the day-to-day workspace for a Moderator. It exposes metrics for campaigns, conversations, Tara activity, human handoffs, AI runs, and failures.

Operational settings can control:
• Whether Tara is enabled.
• Agent name, role description, and general instructions.
• Tone.
• Default and allowed languages.
• Timezone, business hours, and the out-of-hours message.
• Reply delay and maximum reply length.
• Auto Send.
• Default keywords that trigger human handoff.

The workspace also includes areas for campaigns, qualification, knowledge, follow-ups, testing, queue processing, and logs. A queue-processing action is available when manual processing is needed and reports how many items were handled.

The Moderator workspace deliberately avoids exposing API keys or sensitive integration settings. This separates day-to-day operation from secret and infrastructure administration.$enb$,
    'published',85,
    $arseo$إدارة Tara Operations والإعدادات التشغيلية$arseo$,$enseo$Managing Tara Operations and Operational Settings$enseo$,
    $ardesc$اضبط النبرة واللغة وساعات العمل والرد التلقائي والتحويل البشري، وراجع مؤشرات التشغيل والطابور والسجلات.$ardesc$,$endesc$Configure tone, languages, business hours, auto-send, human handoff, operational metrics, queue processing, and logs.$endesc$,
    NOW(),'general',false,NULL,'[]'::jsonb
  ),
  (
    owner_tenant,v_module_id,v_category_id,v_subcategory_id,$s$tcrm-tara-campaigns-qualification$s$,
    $ar$إعداد حملات Tara وحقول تأهيل العملاء$ar$,$en$Configuring Tara Campaigns and Lead Qualification Fields$en$,
    $arx$اربط Tara بالحملات وحدد المراحل والتعيين والأسئلة والحقول المطلوبة وربطها ببيانات CRM.$arx$,$enx$Link Tara to campaigns and configure stages, assignment, qualification questions, required fields, and CRM targets.$enx$,
    $arb$يمكن إعداد Tara بشكل عام أو تخصيص الإعدادات لحملة محددة.

إعداد الحملة يتضمن اسم الحملة ومفتاحها وربطها بحملة CRM عند الحاجة، مع تعليمات وWelcome Message وGoal. كما يمكن تحديد:
• Stage عند إنشاء Lead.
• Stage بعد التأهيل.
• Tags.
• Assignment Mode مثل round-robin أو مالك ثابت حسب الإعداد المتاح.
• Role المستخدم في التعيين.
• Auto Create Lead.
• Handoff Rules.
• Priority.
• Metadata Matchers لاختيار إعداد الحملة المناسب.

Qualification Fields تحدد البيانات التي تسأل عنها Tara أثناء التأهيل. لكل حقل يمكن ضبط Field Key وLabel ونوع الحقل وهل هو Required والخيارات والسؤال الذي ستستخدمه Tara، بالإضافة إلى CRM Field Target وترتيب العرض والحالة Active.

أفضل ممارسة هي البدء بعدد قليل من أسئلة التأهيل الضرورية، وربط كل سؤال بحقل CRM واضح، ثم اختبار السيناريو قبل تفعيل Auto Send.$arb$,$enb$Tara can be configured globally or scoped to a specific campaign.

Campaign configuration includes the campaign name and key, an optional CRM campaign link, instructions, welcome message, and goal. It can also define:
• The stage used when a lead is created.
• The stage used after qualification.
• Tags.
• Assignment mode such as round-robin or a fixed owner when configured.
• Assignment role.
• Auto Create Lead.
• Handoff rules.
• Priority.
• Metadata matchers used to select the correct campaign configuration.

Qualification Fields define the information Tara asks for during qualification. Each field can include a field key, label, field type, required flag, options, the question Tara asks, a CRM field target, sort order, and active status.

A practical approach is to begin with only the essential qualification questions, map each one to a clear CRM target, and test the scenario before enabling live automatic sending.$enb$,
    'published',95,
    $arseo$إعداد حملات Tara وحقول تأهيل العملاء$arseo$,$enseo$Configuring Tara Campaigns and Lead Qualification Fields$enseo$,
    $ardesc$اربط Tara بالحملات وحدد المراحل والتعيين والأسئلة والحقول المطلوبة وربطها ببيانات CRM.$ardesc$,$endesc$Link Tara to campaigns and configure stages, assignment, qualification questions, required fields, and CRM targets.$endesc$,
    NOW(),'general',false,NULL,'[]'::jsonb
  ),
  (
    owner_tenant,v_module_id,v_category_id,v_subcategory_id,$s$tcrm-tara-knowledge-followups$s$,
    $ar$إدارة معرفة Tara وقواعد المتابعة$ar$,$en$Managing Tara Knowledge and Follow-up Rules$en$,
    $arx$أضف Knowledge عامة أو خاصة بحملة، واضبط محاولات المتابعة والتأخير والتوقف عند رد العميل.$arx$,$enx$Add global or campaign-scoped knowledge and configure follow-up attempts, delays, reply-stop rules, and business-hours behavior.$enx$,
    $arb$يمكن توسيع معرفة Tara على مستوى الشركة أو على مستوى حملة محددة باستخدام Scope.

سجل Knowledge يحتوي على Title وKind وContent ويمكن أن يتضمن Source URL وحالة Active. استخدام Scope يسمح بوجود معلومات عامة للشركة ثم إضافة معلومات متخصصة لحملة بعينها بدون خلط السياقات.

Follow-up Rules تستخدم لتنظيم المتابعة بعد المحادثة. القاعدة يمكن أن تحدد:
• Enabled.
• Attempt Number.
• Delay Minutes.
• Message Template.
• Stop On Reply.
• Business Hours Only.

يمكن إنشاء أكثر من محاولة Follow-up بترتيب واضح. تفعيل Stop On Reply يمنع استمرار المتابعات بعد رد العميل، بينما Business Hours Only يقيد الإرسال بساعات العمل المعرفة في إعدادات Tara.

راجع Knowledge ورسائل المتابعة دوريًا، خصوصًا عند تغيير عرض أو خدمة أو سياسة، لأن هذه البيانات تؤثر مباشرة على ردود Tara ومسار التأهيل.$arb$,$enb$Tara knowledge can be extended at company level or scoped to a specific campaign.

A Knowledge record contains a title, kind, content, and can include a source URL and an Active state. Scoping makes it possible to maintain company-wide information while adding campaign-specific information without mixing contexts.

Follow-up Rules control outreach after a conversation. A rule can specify:
• Enabled state.
• Attempt number.
• Delay in minutes.
• Message template.
• Stop On Reply.
• Business Hours Only.

Multiple follow-up attempts can be created in a clear sequence. Stop On Reply prevents later attempts once the customer responds, while Business Hours Only limits the follow-up to Tara's configured business hours.

Review Knowledge and follow-up messages whenever an offer, service, or policy changes because these inputs directly affect Tara replies and the qualification journey.$enb$,
    'published',105,
    $arseo$إدارة معرفة Tara وقواعد المتابعة$arseo$,$enseo$Managing Tara Knowledge and Follow-up Rules$enseo$,
    $ardesc$أضف Knowledge عامة أو خاصة بحملة، واضبط محاولات المتابعة والتأخير والتوقف عند رد العميل.$ardesc$,$endesc$Add global or campaign-scoped knowledge and configure follow-up attempts, delays, reply-stop rules, and business-hours behavior.$endesc$,
    NOW(),'general',false,NULL,'[]'::jsonb
  ),
  (
    owner_tenant,v_module_id,v_category_id,v_subcategory_id,$s$tcrm-tara-moderator-workspace$s$,
    $ar$تشغيل ومراجعة المحادثات من Tara Moderator Workspace$ar$,$en$Operating and Reviewing Conversations in Tara Moderator Workspace$en$,
    $arx$راجع محادثات Tara، ولّد مسودة رد، عدلها وأرسلها، أعد المحاولة عند الفشل، أو أوقف Tara وحوّل المحادثة لموظف.$arx$,$enx$Review Tara conversations, generate and edit reply drafts, send them, retry failures, stop Tara, or hand off a conversation to a human.$enx$,
    $arb$Tara Moderator Workspace مخصصة لمراجعة وتشغيل المحادثات فقط. تعرض Metrics للحسابات والمحادثات والعناصر المنتظرة والأخطاء، مع نطاق الحسابات المسموح للمودريتور بها.

داخل المحادثة الاجتماعية يمكن للمودريتور:
• قراءة الرسائل الواردة والصادرة.
• معرفة هل Tara ON أو OFF لهذه المحادثة.
• Generate Reply للحصول على Draft من Tara.
• مراجعة أو تعديل Draft قبل الإرسال.
• Send Live.
• Retry إذا فشلت عملية AI السابقة.
• إيقاف Tara لهذه المحادثة مع تسجيل سبب الإيقاف.
• تحويل Status إلى Handoff لموظف بشري.
• إضافة Note داخلية.

المساحة تحتوي أيضًا على WhatsApp Evolution للمودريتور الذي لديه حسابات مسموحة على هذا الـPlatform؛ يمكنه اختيار الحساب والمحادثة ومراجعة الرسائل وإرسال رد يدوي وتحديث حالة Tara للمحادثة.

هذه المساحة لا تعرض مفاتيح سرية أو إعدادات تكامل تقنية، وهو فصل مقصود بين المراجعة التشغيلية والإدارة.$arb$,$enb$Tara Moderator Workspace is dedicated to conversation review and operation. It shows metrics for accessible accounts, conversations, queued items, and failures, while respecting the Moderator's allowed account scope.

Within a social conversation, a Moderator can:
• Read inbound and outbound messages.
• See whether Tara is ON or OFF for the conversation.
• Generate a Tara reply draft.
• Review or edit the draft before sending.
• Send the reply live.
• Retry a failed AI run.
• Disable Tara for that conversation and record the reason.
• Change the conversation to human handoff.
• Add an internal note.

The workspace also includes WhatsApp Evolution for Moderators with permitted accounts on that platform. They can select an account and chat, review messages, send a manual reply, and manage Tara conversation status.

Secret keys and technical integration settings are intentionally excluded from this workspace, separating operational review from administration.$enb$,
    'published',115,
    $arseo$تشغيل ومراجعة المحادثات من Tara Moderator Workspace$arseo$,$enseo$Operating and Reviewing Conversations in Tara Moderator Workspace$enseo$,
    $ardesc$راجع محادثات Tara، ولّد مسودة رد، عدلها وأرسلها، أعد المحاولة عند الفشل، أو أوقف Tara وحوّل المحادثة لموظف.$ardesc$,$endesc$Review Tara conversations, generate and edit reply drafts, send them, retry failures, stop Tara, or hand off a conversation to a human.$endesc$,
    NOW(),'general',false,NULL,'[]'::jsonb
  ),
  (
    owner_tenant,v_module_id,v_category_id,v_subcategory_id,$s$tcrm-tara-moderator-management$s$,
    $ar$تعيين Tara Moderators وتحديد نطاق الحسابات$ar$,$en$Assigning Tara Moderators and Account Scopes$en$,
    $arx$فعّل دور Moderator للمستخدم وحدد كل الحسابات أو Accounts معينة، مع حماية أدوار Admin وSuperAdmin.$arx$,$enx$Enable the Moderator role, grant all accounts or selected account scopes, and preserve protection for privileged admin roles.$enx$,
    $arb$Tara Moderator Management تسمح للإدارة بتحديد من يمكنه تشغيل ومراجعة محادثات Tara.

عند اختيار مستخدم يمكن:
• تفعيل أو تعطيل Role Moderator.
• منحه All Accounts.
• أو اختيار Accounts محددة حسب Platform وAccount ID.
• حفظ Scopes لكل Moderator.

الواجهة تستبعد أدوار Admin وSuperAdmin وSuperAdministrator من قائمة المستخدمين التي يتم تحويلها إلى Moderator، لحماية الأدوار الإدارية المميزة من الاستبدال بهذه الطريقة.

عند إلغاء Moderator يجب اختيار Replacement Role من الأدوار المتاحة مثل Viewer أو SalesAgent أو SalesManager أو AccountManager أو TechnicalAccountManager أو MediaBuyer أو BusinessDeveloper.

استخدم All Accounts فقط لمن يحتاج فعليًا رؤية كل محادثات Tara. لباقي الفريق، الأفضل تحديد Scope دقيق لكل حساب أو منصة.$arb$,$enb$Tara Moderator Management lets administrators decide who can operate and review Tara conversations.

For a selected user, an administrator can:
• Enable or disable the Moderator role.
• Grant access to All Accounts.
• Or select specific accounts by platform and account ID.
• Save account scopes for each Moderator.

The interface excludes Admin, SuperAdmin, and SuperAdministrator roles from the list of users that can be converted into Moderators, protecting privileged administrative roles from accidental replacement through this workflow.

When Moderator access is disabled, a replacement role must be selected from available roles such as Viewer, SalesAgent, SalesManager, AccountManager, TechnicalAccountManager, MediaBuyer, or BusinessDeveloper.

Use All Accounts only when a Moderator genuinely needs company-wide access. For most operators, define a narrow account or platform scope.$enb$,
    'published',125,
    $arseo$تعيين Tara Moderators وتحديد نطاق الحسابات$arseo$,$enseo$Assigning Tara Moderators and Account Scopes$enseo$,
    $ardesc$فعّل دور Moderator للمستخدم وحدد كل الحسابات أو Accounts معينة، مع حماية أدوار Admin وSuperAdmin.$ardesc$,$endesc$Enable the Moderator role, grant all accounts or selected account scopes, and preserve protection for privileged admin roles.$endesc$,
    NOW(),'general',false,NULL,'[]'::jsonb
  ),
  (
    owner_tenant,v_module_id,v_category_id,v_subcategory_id,$s$tcrm-tara-social-channels-meta$s$,
    $ar$ربط Tara بقنوات Meta وإدارة Social Inbox$ar$,$en$Connecting Tara to Meta Channels and Managing the Social Inbox$en$,
    $arx$أضف Messenger وInstagram والComments، اضبط Meta OAuth وطريقة الرد، وولّد أو أرسل الردود واربط المحادثة بـCRM.$arx$,$enx$Add Messenger, Instagram, and comment channels, configure Meta OAuth and reply modes, send replies, and create or link CRM leads.$enx$,
    $arb$Social Channels في Tara تدعم قنوات مثل Facebook Messenger وInstagram Direct وFacebook Comments وInstagram Comments، بالإضافة إلى TikTok كقناة مستقلة.

عند إضافة قناة يمكن تحديد Display Name وطريقة الرد الافتراضية:
• Suggest: Tara تقترح الرد للمراجعة.
• Auto Reply: رد تلقائي.
• Handoff Only: تحويل بشري فقط.

Meta Settings تشمل App ID وApp Secret وVerify Token وGraph Version وPublic URL وRedirect URI. يتم اختبار الإعدادات ثم يمكن بدء OAuth واختيار الصفحة وربطها بالقناة واختبار الاتصال.

Social Inbox يسمح باختيار المحادثة ومراجعة الرسائل ونتيجة آخر AI run. يمكن Generate Social Reply ثم مراجعة Draft وإرساله. كما توجد إجراءات لإنشاء أو ربط Lead في CRM وتحديث حالة المحادثة.

تشغيل Tara الفعلي للمحادثة يعتمد على تفعيل القناة نفسها وتفعيل Tara للمحادثة؛ إذا كان أحد المستويين متوقفًا فلا تعتبر Tara فعالة للمحادثة.$arb$,$enb$Tara Social Channels support Facebook Messenger, Instagram Direct, Facebook Comments, and Instagram Comments, with TikTok handled as an additional channel type.

When adding a channel, you can set its display name and default reply mode:
• Suggest: Tara prepares a reply for review.
• Auto Reply: automatic reply.
• Handoff Only: human handoff only.

Meta Settings include App ID, App Secret, Verify Token, Graph Version, Public URL, and Redirect URI. The configuration can be tested before starting OAuth, selecting a Meta page, associating it with the channel, and testing the connected channel.

The Social Inbox lets the operator select a conversation, review messages and the latest AI run, generate a social reply draft, review it, and send it. The operator can also create or link a CRM lead and update conversation state.

Tara is effectively enabled for a conversation only when both the account/channel level and the conversation level permit Tara.$enb$,
    'published',135,
    $arseo$ربط Tara بقنوات Meta وإدارة Social Inbox$arseo$,$enseo$Connecting Tara to Meta Channels and Managing the Social Inbox$enseo$,
    $ardesc$أضف Messenger وInstagram والComments، اضبط Meta OAuth وطريقة الرد، وولّد أو أرسل الردود واربط المحادثة بـCRM.$ardesc$,$endesc$Add Messenger, Instagram, and comment channels, configure Meta OAuth and reply modes, send replies, and create or link CRM leads.$endesc$,
    NOW(),'general',false,NULL,'[]'::jsonb
  ),
  (
    owner_tenant,v_module_id,v_category_id,v_subcategory_id,$s$tcrm-tara-tiktok-business-messaging$s$,
    $ar$إعداد TikTok Business Messaging الرسمي في Tara$ar$,$en$Setting Up Official TikTok Business Messaging in Tara$en$,
    $arx$اضبط Client ID وSecret وOAuth وWebhook، واربط حساب TikTok واختبر الصلاحيات المطلوبة قبل تشغيل الرسائل.$arx$,$enx$Configure Client ID, secret, OAuth, and webhook, then connect a TikTok account and verify required messaging permissions.$enx$,
    $arb$تكامل TikTok في Tara يعتمد على TikTok Business Messaging API الرسمي فقط. الواجهة توضح أن الخدمة تحتاج موافقة TikTok على الـAPI للحساب والتطبيق ولا تستخدم API غير رسمي أو محاكاة.

قبل الربط:
1. أضف قناة من نوع TikTok في Social Channels.
2. أدخل Client ID / App ID.
3. أدخل Client Secret.
4. اضبط OAuth Redirect URI.
5. اضبط Webhook URL وWebhook Event Type.
6. احفظ الإعدادات.
7. سجل Webhook عندما تصبح Configuration جاهزة.
8. استخدم Connect TikTok لبدء OAuth.
9. اختبر الاتصال.

لكل قناة يظهر Connected / Not Connected وحالة Scopes. إذا كانت هناك Missing Scopes تعرضها الواجهة بوضوح. كما يظهر Last Test Status وموعد انتهاء Access Token عند توفره.

لا تعتبر قناة TikTok جاهزة للإرسال لمجرد نجاح OAuth؛ يجب التأكد أيضًا من اعتماد صلاحيات Business Messaging المطلوبة.$arb$,$enb$Tara's TikTok integration uses the official TikTok Business Messaging API only. The interface explicitly states that the account and app must be approved for Business Messaging and that no unofficial API or simulation is used.

Before connecting:
1. Add a TikTok-type channel in Social Channels.
2. Enter the Client ID / App ID.
3. Enter the Client Secret.
4. Configure the OAuth Redirect URI.
5. Configure the Webhook URL and webhook event type.
6. Save the settings.
7. Register the webhook once the configuration is ready.
8. Use Connect TikTok to start OAuth.
9. Test the connection.

Each TikTok channel shows Connected / Not Connected and its scope status. Missing scopes are displayed explicitly. Last Test Status and access-token expiry can also be shown when available.

Do not treat a successful OAuth connection alone as messaging readiness; the required Business Messaging scopes must also be approved.$enb$,
    'published',145,
    $arseo$إعداد TikTok Business Messaging الرسمي في Tara$arseo$,$enseo$Setting Up Official TikTok Business Messaging in Tara$enseo$,
    $ardesc$اضبط Client ID وSecret وOAuth وWebhook، واربط حساب TikTok واختبر الصلاحيات المطلوبة قبل تشغيل الرسائل.$ardesc$,$endesc$Configure Client ID, secret, OAuth, and webhook, then connect a TikTok account and verify required messaging permissions.$endesc$,
    NOW(),'general',false,NULL,'[]'::jsonb
  ),
  (
    owner_tenant,v_module_id,v_category_id,v_subcategory_id,$s$tcrm-tara-voice-elevenlabs$s$,
    $ar$إعداد Tara Voice وElevenLabs بأمان$ar$,$en$Configuring Tara Voice and ElevenLabs Safely$en$,
    $arx$احفظ مفتاح ElevenLabs، حمّل الأصوات، اختر STT/TTS، اختبر الاتصال والمعاينة، ثم فعّل الخدمة للحسابات المناسبة.$arx$,$enx$Save the ElevenLabs key, load voices, select STT/TTS models, test and preview, then enable voice for the appropriate accounts.$enx$,
    $arb$Tara Voice تستخدم ElevenLabs لإدارة الصوت وSTT/TTS. إعدادات الصوت مقيدة في الواجهة للمستخدم الإداري المناسب، وتعرض رسالة واضحة إذا لم تكن الصلاحية متاحة.

الترتيب الآمن الذي تعرضه الواجهة:
1. احفظ ElevenLabs API Key.
2. حمّل Catalog الأصوات والنماذج.
3. اختر Voice الرسمي لتارا ونماذج STT وTTS.
4. احفظ الإعدادات.
5. نفّذ اختبار الاتصال واختبار STT+TTS المطلوب.
6. فعّل Tara Voice عالميًا بعد اكتمال Activation Readiness.
7. فعّل الحسابات المطلوبة من قائمة الحسابات.

أنماط الرد تشمل Smart وVoice Only وVoice + Text وText Only وManual Approval. كما يمكن حفظ إعداد مختلف لمحادثة محددة، بما في ذلك Platform وAccount وConversation والـResponse Mode والـVoice.

المفتاح يُحفظ بطريقة لا تعيده كاملًا للمتصفح بعد الحفظ، ويمكن مسحه صراحة. إذا لم ينجح اختبار التفعيل، قد يحفظ النظام الإعدادات مع إبقاء Voice متوقفة حتى إعادة الاختبار.$arb$,$enb$Tara Voice uses ElevenLabs for voice, STT, and TTS workflows. Voice configuration is restricted to the appropriate administrative access and the interface shows a clear permission message when access is unavailable.

The safe order presented by the interface is:
1. Save the ElevenLabs API key.
2. Load the available voice and model catalog.
3. Select Tara's voice and the STT/TTS models.
4. Save the configuration.
5. Run the connection and required STT+TTS activation tests.
6. Enable Tara Voice globally after activation readiness is satisfied.
7. Enable the required accounts from the account list.

Response modes include Smart, Voice Only, Voice + Text, Text Only, and Manual Approval. A conversation-level setting can also override behavior using platform, account, conversation, response mode, and voice.

The API key is stored without returning the full secret to the browser after saving and can be explicitly cleared. If activation testing is not satisfied, settings may be saved while Voice remains disabled until it is retested.$enb$,
    'published',155,
    $arseo$إعداد Tara Voice وElevenLabs بأمان$arseo$,$enseo$Configuring Tara Voice and ElevenLabs Safely$enseo$,
    $ardesc$احفظ مفتاح ElevenLabs، حمّل الأصوات، اختر STT/TTS، اختبر الاتصال والمعاينة، ثم فعّل الخدمة للحسابات المناسبة.$ardesc$,$endesc$Save the ElevenLabs key, load voices, select STT/TTS models, test and preview, then enable voice for the appropriate accounts.$endesc$,
    NOW(),'general',false,NULL,'[]'::jsonb
  ),
  (
    owner_tenant,v_module_id,v_category_id,v_subcategory_id,$s$tcrm-tara-ai-providers$s$,
    $ar$إدارة مزودي الذكاء الاصطناعي الأساسي والاحتياطي في Tara$ar$,$en$Managing Primary and Fallback AI Providers in Tara$en$,
    $arx$فعّل OpenAI أو Gemini أو Claude أو Agnes أو مزودًا متوافقًا، واختر Primary ورتب Fallback واختبر كل اتصال.$arx$,$enx$Enable OpenAI, Gemini, Claude, Agnes, or a compatible custom provider, then configure primary/fallback order and test each connection.$enx$,
    $arb$Tara تدعم عدة مزودي AI في نفس الإعداد: OpenAI وGoogle Gemini وAnthropic Claude وAgnes AI وCustom OpenAI-compatible.

لكل Provider يمكن ضبط:
• Enabled.
• API Key.
• Base URL.
• Model.
• Fallback Priority.
• اختبار الاتصال.
• تحميل Models المتاحة عند دعم المزود لذلك.

يتم اختيار Primary Provider من المزودين المفعّلين، ثم يرتب النظام المزودين الآخرين كـFallback حسب الأولوية. المزود المتوقف لا يدخل في الـPrimary أو Fallback.

المفاتيح المحفوظة تظهر Masked ولا تعود كاملة للواجهة. وقد يكون المفتاح قادمًا من Environment Secret؛ في هذه الحالة لا يمكن مسحه من الصفحة. المزود Custom يستخدم OpenAI-compatible endpoint عبر HTTPS فقط، ويمكن للخادم تقييد الـHosts المسموح بها.

بعد أي تغيير مهم احفظ الإعداد أولًا ثم نفذ Test للمزود. لا تعتمد على وجود API Key فقط كدليل على جاهزية الاتصال.$arb$,$enb$Tara supports multiple AI providers in one configuration: OpenAI, Google Gemini, Anthropic Claude, Agnes AI, and a Custom OpenAI-compatible provider.

Each provider can define:
• Enabled state.
• API key.
• Base URL.
• Model.
• Fallback priority.
• Connection testing.
• Loading available models where supported.

A Primary Provider is selected from enabled providers, while other enabled providers are ordered as fallbacks by priority. A disabled provider is excluded from both primary and fallback use.

Saved keys are displayed only in masked form and are not returned in full to the browser. A key can also originate from an environment secret; in that case it cannot be cleared from this page. The Custom provider uses an OpenAI-compatible endpoint over HTTPS and the server can restrict allowed hosts.

After a meaningful configuration change, save it first and then run the provider test. The presence of an API key alone should not be treated as proof that the provider is ready.$enb$,
    'published',165,
    $arseo$إدارة مزودي الذكاء الاصطناعي الأساسي والاحتياطي في Tara$arseo$,$enseo$Managing Primary and Fallback AI Providers in Tara$enseo$,
    $ardesc$فعّل OpenAI أو Gemini أو Claude أو Agnes أو مزودًا متوافقًا، واختر Primary ورتب Fallback واختبر كل اتصال.$ardesc$,$endesc$Enable OpenAI, Gemini, Claude, Agnes, or a compatible custom provider, then configure primary/fallback order and test each connection.$endesc$,
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
      'tcrm-ai-staff-tara',
      'tcrm-tara-operations',
      'tcrm-tara-campaigns-qualification',
      'tcrm-tara-knowledge-followups',
      'tcrm-tara-moderator-workspace',
      'tcrm-tara-moderator-management',
      'tcrm-tara-social-channels-meta',
      'tcrm-tara-tiktok-business-messaging',
      'tcrm-tara-voice-elevenlabs',
      'tcrm-tara-ai-providers'
    )
    AND status = 'published'
    AND visibility_scope = 'general'
    AND consumer_hidden = false
    AND length(trim(title_ar)) > 0
    AND length(trim(title_en)) > 0
    AND length(trim(body_ar)) > 0
    AND length(trim(body_en)) > 0;

  IF published_count <> 10 THEN
    RAISE EXCEPTION 'TCRMHC_PHASE15_CONTENT_VERIFY_FAILED expected=10 actual=%', published_count;
  END IF;
END $$;

COMMIT;
