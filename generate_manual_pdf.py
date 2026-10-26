import sys
import os
from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, KeepTogether, HRFlowable
)
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.enums import TA_CENTER, TA_LEFT, TA_RIGHT, TA_JUSTIFY
from reportlab.pdfgen import canvas

PDF_FILE = "ShopWave_Comprehensive_User_Manual.pdf"

class NumberedCanvas(canvas.Canvas):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._saved_page_states = []

    def showPage(self):
        self._saved_page_states.append(dict(self.__dict__))
        self._startPage()

    def save(self):
        num_pages = len(self._saved_page_states)
        for state in self._saved_page_states:
            self.__dict__.update(state)
            self.draw_page_decorations(num_pages)
            super().showPage()
        super().save()

    def draw_page_decorations(self, page_count):
        if self._pageNumber == 1:
            return  # Suppress headers/footers on cover

        self.saveState()
        self.setFont("Helvetica-Bold", 8)
        self.setFillColor(colors.HexColor("#64748B"))

        # Running Header
        self.drawString(45, 804, "ShopWave Platform Manual — AI-Powered Multi-Store E-Commerce Engine")
        self.setStrokeColor(colors.HexColor("#CBD5E1"))
        self.setLineWidth(0.75)
        self.line(45, 796, 550, 796)

        # Running Footer
        self.line(45, 42, 550, 42)
        self.setFont("Helvetica", 8)
        self.drawString(45, 30, "ShopWave 2.0 • Powered by Flutter 3.47, FastAPI & Google Gemini 2.5 Flash")
        page_text = f"Page {self._pageNumber} of {page_count}"
        self.drawRightString(550, 30, page_text)
        self.restoreState()

def build_pdf():
    doc = SimpleDocTemplate(
        PDF_FILE,
        pagesize=A4,
        leftMargin=45,
        rightMargin=45,
        topMargin=45,
        bottomMargin=45
    )

    styles = getSampleStyleSheet()
    
    # Custom Palette
    c_primary = colors.HexColor("#4F46E5")     # Electric Indigo
    c_dark = colors.HexColor("#0F172A")        # Obsidian Slate
    c_secondary = colors.HexColor("#0EA5E9")   # Sky Blue
    c_rose = colors.HexColor("#F43F5E")        # Rose Coral
    c_slate = colors.HexColor("#334155")       # Text Slate
    c_light = colors.HexColor("#F8FAFC")       # Soft Canvas
    c_border = colors.HexColor("#CBD5E1")

    # Typography Styles
    title_style = ParagraphStyle(
        'CoverTitle',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=24,
        leading=30,
        textColor=colors.white,
        alignment=TA_CENTER
    )
    subtitle_style = ParagraphStyle(
        'CoverSubtitle',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=11,
        leading=16,
        textColor=colors.HexColor("#CBD5E1"),
        alignment=TA_CENTER
    )
    h1_style = ParagraphStyle(
        'Header1',
        parent=styles['Heading1'],
        fontName='Helvetica-Bold',
        fontSize=14,
        leading=18,
        textColor=c_dark,
        spaceBefore=11,
        spaceAfter=5,
        keepWithNext=True
    )
    h2_style = ParagraphStyle(
        'Header2',
        parent=styles['Heading2'],
        fontName='Helvetica-Bold',
        fontSize=10.5,
        leading=14,
        textColor=c_primary,
        spaceBefore=7,
        spaceAfter=3,
        keepWithNext=True
    )
    body_style = ParagraphStyle(
        'BodyDark',
        parent=styles['BodyText'],
        fontName='Helvetica',
        fontSize=8.5,
        leading=12.5,
        textColor=c_slate,
        spaceAfter=4,
        alignment=TA_JUSTIFY
    )
    bullet_style = ParagraphStyle(
        'BulletText',
        parent=body_style,
        leftIndent=14,
        firstLineIndent=-10,
        spaceAfter=2.5,
        alignment=TA_LEFT
    )
    callout_style = ParagraphStyle(
        'CalloutText',
        parent=body_style,
        fontSize=8,
        leading=11.5,
        textColor=colors.HexColor("#1E293B")
    )
    table_cell = ParagraphStyle(
        'TableCell',
        parent=body_style,
        fontSize=7.5,
        leading=10.5,
        textColor=c_dark
    )
    table_header = ParagraphStyle(
        'TableHeader',
        parent=table_cell,
        fontName='Helvetica-Bold',
        textColor=colors.white
    )

    story = []

    # ================= COVER PAGE (PAGE 1) =================
    story.append(Spacer(1, 15))
    cover_table_data = [
        [
            Paragraph("🛍️ SHOPWAVE PLATFORM", ParagraphStyle('Badge', fontName='Helvetica-Bold', fontSize=12, textColor=c_secondary, alignment=TA_CENTER)),
        ],
        [Spacer(1, 8)],
        [
            Paragraph("Complete User Manual &<br/>Platform Architecture Guide", title_style)
        ],
        [Spacer(1, 6)],
        [
            Paragraph("AI-Powered Multi-Retailer Recommendation Engine & E-Commerce Application<br/>Cross-Shopping Amazon India, Flipkart, Croma & ShopWave", subtitle_style)
        ],
        [Spacer(1, 14)],
        [
            Paragraph(
                "<b>Core Stack:</b> Flutter 3.47 • FastAPI AI Backend • Google Gemini 2.5 Flash • Supabase (PostgreSQL with RLS)",
                ParagraphStyle('CoverMeta', fontName='Helvetica', fontSize=9.5, textColor=colors.HexColor("#94A3B8"), alignment=TA_CENTER)
            )
        ]
    ]
    cover_table = Table(cover_table_data, colWidths=[505])
    cover_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, -1), c_dark),
        ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
        ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
        ('TOPPADDING', (0, 0), (-1, -1), 22),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 22),
        ('LEFTPADDING', (0, 0), (-1, -1), 20),
        ('RIGHTPADDING', (0, 0), (-1, -1), 20),
    ]))
    story.append(cover_table)

    story.append(Spacer(1, 20))

    meta_info_data = [
        [Paragraph("<b>Document Version:</b> 2.0 (Production Release)", body_style), Paragraph("<b>Release Date:</b> October 2026", body_style)],
        [Paragraph("<b>Architecture:</b> Microservices + Hybrid Client", body_style), Paragraph("<b>AI Engine:</b> Gemini 2.5 Flash (Multimodal Vision & NLP)", body_style)],
        [Paragraph("<b>Test Coverage:</b> 100% Passed (18 Flutter / 6 Backend)", body_style), Paragraph("<b>Target Platforms:</b> Web (Chrome), Android, iOS, Windows", body_style)],
    ]
    meta_table = Table(meta_info_data, colWidths=[250, 255])
    meta_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, -1), c_light),
        ('BOX', (0, 0), (-1, -1), 1, c_border),
        ('INNERGRID', (0, 0), (-1, -1), 0.5, c_border),
        ('TOPPADDING', (0, 0), (-1, -1), 8),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 8),
        ('LEFTPADDING', (0, 0), (-1, -1), 12),
        ('RIGHTPADDING', (0, 0), (-1, -1), 12),
    ]))
    story.append(meta_table)

    story.append(Spacer(1, 20))

    overview_box_data = [[
        Paragraph(
            "<b>Welcome to ShopWave:</b><br/>"
            "This manual provides step-by-step instructions for operating the ShopWave mobile and web platform. "
            "Whether you are evaluating the intelligent multi-retailer recommendation algorithms, testing the Gemini 2.5 Flash "
            "conversational assistant, comparing prices across authorized Indian retailers, or exploring the PostgreSQL RLS "
            "security policies, this document details all procedures, endpoints, and architectural components.",
            callout_style
        )
    ]]
    overview_box = Table(overview_box_data, colWidths=[505])
    overview_box.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, -1), colors.HexColor("#EEF2FF")),
        ('BOX', (0, 0), (-1, -1), 1, c_primary),
        ('PADDING', (0, 0), (-1, -1), 10),
    ]))
    story.append(overview_box)

    story.append(PageBreak())

    # ================= PAGE 2: ARCHITECTURE & SETUP =================
    story.append(Paragraph("1. Executive Overview & System Architecture", h1_style))
    story.append(HRFlowable(width="100%", thickness=1.2, color=c_primary, spaceBefore=2, spaceAfter=8))
    story.append(Paragraph(
        "<b>ShopWave</b> aggregates live product listings from <b>Amazon India</b>, <b>Flipkart</b>, <b>Croma</b>, and local <b>ShopWave</b> merchants into a single unified shopping platform. Using Google's Gemini 2.5 Flash multimodal model and Bayesian recommendation mathematics, ShopWave provides real-time side-by-side matrices, conversational budget shopping assistance, image-based visual matching, and automated price-drop tracking with offline resiliency.",
        body_style
    ))

    arch_box_data = [[
        Paragraph(
            "<b>Key Architecture Components:</b><br/>"
            "• <b>Flutter Frontend:</b> Clean Architecture with BLoC 9.0, get_it DI locator, and go_router deep linking.<br/>"
            "• <b>FastAPI AI Orchestrator:</b> High-throughput async REST microservice with Uvicorn, computing Bayesian confidence ratings.<br/>"
            "• <b>Google Gemini 2.5 Flash:</b> Multimodal NLP for intent parsing, budget extraction, and visual image categorization.<br/>"
            "• <b>Supabase PostgreSQL:</b> Row-Level Security (RLS) tenant isolation for user profiles, carts, wishlists, and orders.<br/>"
            "• <b>Offline Resiliency Layer:</b> Local storage caching providing zero-connectivity graceful degradation.",
            callout_style
        )
    ]]
    arch_box = Table(arch_box_data, colWidths=[505])
    arch_box.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, -1), colors.HexColor("#EEF2FF")),
        ('BOX', (0, 0), (-1, -1), 1, c_primary),
        ('PADDING', (0, 0), (-1, -1), 8),
    ]))
    story.append(arch_box)
    story.append(Spacer(1, 6))

    story.append(Paragraph("2. Getting Started & Environment Setup", h1_style))
    story.append(HRFlowable(width="100%", thickness=1.2, color=c_primary, spaceBefore=2, spaceAfter=8))

    story.append(Paragraph("<b>Prerequisites:</b> Python 3.10+, Flutter 3.27+ (Dart 3.13+), and Google Chrome or Android emulator.", body_style))

    story.append(Paragraph("Step 1: Verify Environment (.env)", h2_style))
    story.append(Paragraph("Ensure the root <code>.env</code> file is configured with the following parameters:", body_style))
    
    env_data = [[
        Paragraph(
            "<code>SUPABASE_URL=https://xyzcompany.supabase.co<br/>"
            "SUPABASE_ANNONKEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.fake_key<br/>"
            "BACKEND_API_URL=http://localhost:8000<br/>"
            "GEMINI_API_KEY=your_gemini_api_key_here</code>",
            ParagraphStyle('EnvCode', fontName='Courier', fontSize=7.5, leading=11, textColor=c_dark)
        )
    ]]
    env_box = Table(env_data, colWidths=[505])
    env_box.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, -1), colors.HexColor("#F1F5F9")),
        ('BOX', (0, 0), (-1, -1), 1, c_border),
        ('PADDING', (0, 0), (-1, -1), 6),
    ]))
    story.append(env_box)

    story.append(Paragraph("Step 2: Start the FastAPI AI Backend", h2_style))
    story.append(Paragraph("From the root directory, start the Uvicorn server:", body_style))
    story.append(Paragraph("<code>python -m uvicorn backend.main:app --host 127.0.0.1 --port 8000</code>", bullet_style))
    story.append(Paragraph("Interactive OpenAPI/Swagger documentation is available at: <b>http://127.0.0.1:8000/docs</b>.", body_style))

    story.append(Paragraph("Step 3: Launch the Flutter Web Application", h2_style))
    story.append(Paragraph("Run the application targeting Google Chrome:", body_style))
    story.append(Paragraph("<code>flutter run -d chrome --web-port 3000</code>", bullet_style))
    story.append(Paragraph("The application will bundle all assets and open automatically at: <b>http://localhost:3000</b>.", body_style))

    story.append(PageBreak())

    # ================= PAGE 3: FEATURE GUIDE =================
    story.append(Paragraph("3. Complete Feature Walkthrough & How to Use", h1_style))
    story.append(HRFlowable(width="100%", thickness=1.2, color=c_primary, spaceBefore=2, spaceAfter=8))

    story.append(Paragraph("Feature 1: Interactive Home Screen & Multi-Store Discovery", h2_style))
    story.append(Paragraph("• <b>Store Filter Bar:</b> Tap on <i>All Stores</i>, <i>Amazon India</i>, <i>Flipkart</i>, or <i>Croma</i> pills to instantly refine product listings.", bullet_style))
    story.append(Paragraph("• <b>AI Copilot Hero Banner:</b> Dark obsidian gradient card with one-touch prompt chips ('Best Phone under 25k', 'Gaming Laptops') for instant AI shopping consultations.", bullet_style))
    story.append(Paragraph("• <b>Discount Ribbons & Ratings:</b> Clearly badges percentage savings (e.g. '15% OFF') and 4.8★ rating scores on all product cards.", bullet_style))
    story.append(Paragraph("• <b>Optimistic Wishlisting:</b> Tap the floating heart icon on any card to save items with offline caching.", bullet_style))

    story.append(Paragraph("Feature 2: Google Gemini 2.5 Flash AI Shopping Copilot", h2_style))
    story.append(Paragraph(
        "Accessible via the top glowing AI icon or hero button. The AI assistant processes conversational shopping requests:",
        body_style
    ))
    story.append(Paragraph("• <b>Budget Parsing:</b> Extracts constraints such as <i>'under 50k'</i>, <i>'below Rs. 30,000'</i>, or <i>'worth Rs. 2,500'</i>.", bullet_style))
    story.append(Paragraph("• <b>Feature Detection:</b> Automatically identifies keywords for ANC, Battery, High-Res Camera, Gaming, or AMOLED display.", bullet_style))
    story.append(Paragraph("• <b>Transparent Explanations:</b> Explains exactly why a product is recommended (e.g. <i>'Fits budget of Rs. 50,000, saves Rs. 5,000, and has 4.8★ rating from 1,200 reviews'</i>).", bullet_style))

    story.append(Paragraph("Feature 3: Side-by-Side Product Comparison Matrix", h2_style))
    story.append(Paragraph(
        "Tap the comparison icon in the AppBar or <b>Compare Across Stores</b> on any Product Detail screen. The matrix evaluates:",
        body_style
    ))
    story.append(Paragraph("• <b>Best Price & Savings:</b> Identifies the single lowest price across Amazon India, Flipkart, and Croma.", bullet_style))
    story.append(Paragraph("• <b>Confidence Scores:</b> Compares review volume and weighted Bayesian scores.", bullet_style))
    story.append(Paragraph("• <b>Delivery & Warranty:</b> Outlines delivery timelines (e.g., 2-Day Prime vs Standard) and return policies.", bullet_style))
    story.append(Paragraph("• <b>Direct Redirects:</b> One-touch affiliate redirection to authorized stores via <code>url_launcher</code>.", bullet_style))

    story.append(Paragraph("Feature 4: Multimodal Visual Image Search", h2_style))
    story.append(Paragraph(
        "Tap <b>Visual Search</b> to identify and price-match products from photos:",
        body_style
    ))
    story.append(Paragraph("• <b>Camera & Gallery Input:</b> Take a real-time photo or select an existing image.", bullet_style))
    story.append(Paragraph("• <b>Gemini Vision Pipeline:</b> Extracts product categories, model clues, and color palettes from image base64 data.", bullet_style))
    story.append(Paragraph("• <b>Cross-Store Matching:</b> Calculates cosine similarity to match visual features against available store catalogs.", bullet_style))

    story.append(Paragraph("Feature 5: 30-Day Historical Price Tracking & Drop Alerts", h2_style))
    story.append(Paragraph("• <b>Interactive Timeline:</b> Graph on every product detail page displaying lowest, highest, and 30-day average prices.", bullet_style))
    story.append(Paragraph("• <b>Trend Detection:</b> Automatically calculates whether current pricing is <i>'dropping'</i>, <i>'stable'</i>, or <i>'rising'</i>.", bullet_style))
    story.append(Paragraph("• <b>Price Drop Alerts:</b> Subscribe to target price thresholds to receive automated notification alerts.", bullet_style))

    story.append(Paragraph("Feature 6: Zero-Connectivity Offline Resiliency", h2_style))
    story.append(Paragraph(
        "Powered by <code>OfflineCacheService</code> and <code>shared_preferences</code>, ShopWave provides full offline resilience. If internet connection drops, the app immediately switches to locally cached categories, products, wishlists, and user preferences with zero blank screens or crashes.",
        body_style
    ))

    story.append(PageBreak())

    # ================= PAGE 4: APIS, SECURITY & FAQ =================
    story.append(Paragraph("4. Backend REST API Endpoints Specification", h1_style))
    story.append(HRFlowable(width="100%", thickness=1.2, color=c_primary, spaceBefore=2, spaceAfter=8))

    api_table_data = [
        [Paragraph("Endpoint", table_header), Paragraph("Method", table_header), Paragraph("Description", table_header), Paragraph("Sample Request Payload / Param", table_header)],
        [Paragraph("<code>/health</code>", table_cell), Paragraph("<b>GET</b>", table_cell), Paragraph("Health check & active providers status", table_cell), Paragraph("None", table_cell)],
        [Paragraph("<code>/api/v1/search</code>", table_cell), Paragraph("<b>POST</b>", table_cell), Paragraph("Aggregates products across all stores with sorting & price bounds", table_cell), Paragraph("<code>{\"query\": \"laptop\", \"min_price\": 40000}</code>", table_cell)],
        [Paragraph("<code>/api/v1/assistant</code>", table_cell), Paragraph("<b>POST</b>", table_cell), Paragraph("Gemini AI intent extraction & shopping advice", table_cell), Paragraph("<code>{\"message\": \"best phone under 30k\"}</code>", table_cell)],
        [Paragraph("<code>/api/v1/compare</code>", table_cell), Paragraph("<b>POST</b>", table_cell), Paragraph("Generates side-by-side merchant comparison matrix", table_cell), Paragraph("<code>{\"product_title\": \"iPhone 15\"}</code>", table_cell)],
        [Paragraph("<code>/api/v1/visual-search</code>", table_cell), Paragraph("<b>POST</b>", table_cell), Paragraph("Multimodal image attribute extraction & visual match", table_cell), Paragraph("<code>{\"image_base64\": \"...\"}</code>", table_cell)],
        [Paragraph("<code>/api/v1/price-history/{id}</code>", table_cell), Paragraph("<b>GET</b>", table_cell), Paragraph("Returns 30-day price timeline & trend direction", table_cell), Paragraph("<code>Path: id=prod_1</code>", table_cell)],
    ]
    api_table = Table(api_table_data, colWidths=[110, 48, 175, 172])
    api_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), c_dark),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
        ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, c_light]),
        ('GRID', (0, 0), (-1, -1), 0.5, c_border),
        ('TOPPADDING', (0, 0), (-1, -1), 4),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 4),
        ('LEFTPADDING', (0, 0), (-1, -1), 6),
        ('RIGHTPADDING', (0, 0), (-1, -1), 6),
    ]))
    story.append(api_table)

    story.append(Spacer(1, 8))
    story.append(Paragraph("5. Database Security Architecture (PostgreSQL RLS)", h1_style))
    story.append(HRFlowable(width="100%", thickness=1.2, color=c_primary, spaceBefore=2, spaceAfter=8))
    story.append(Paragraph(
        "All user tables implement strict Row-Level Security (RLS) in <code>supabase/migrations/01_ai_ecommerce_enhancements.sql</code>:",
        body_style
    ))
    story.append(Paragraph("• <b>wishlists:</b> Composite primary key on <code>(user_id, product_id)</code> with RLS policy <code>auth.uid() = user_id</code> ensuring complete tenant isolation.", bullet_style))
    story.append(Paragraph("• <b>product_reviews:</b> Stores verified buyer reviews and star ratings (1-5).", bullet_style))
    story.append(Paragraph("• <b>price_history & price_alerts:</b> Automated threshold tracking and alert subscriptions.", bullet_style))
    story.append(Paragraph("• <b>user_preferences:</b> Default budget limits, preferred retailers, and notification flags.", bullet_style))

    story.append(Spacer(1, 8))
    story.append(Paragraph("6. Frequently Asked Questions & Troubleshooting", h1_style))
    story.append(HRFlowable(width="100%", thickness=1.2, color=c_primary, spaceBefore=2, spaceAfter=8))

    faq_data = [
        [
            Paragraph("<b>Q: What happens if there is no internet connection?</b><br/>"
                      "<b>A:</b> ShopWave features zero-connectivity offline resiliency. Curated categories and high-definition products are cached locally, and search queries fall back to verified offline data seamlessly.", body_style)
        ],
        [
            Paragraph("<b>Q: Can I use my own Supabase database keys?</b><br/>"
                      "<b>A:</b> Yes. Update <code>SUPABASE_URL</code> and <code>SUPABASE_ANNONKEY</code> in the root <code>.env</code> file. The app will immediately link to your remote PostgreSQL instance and authenticate live users.", body_style)
        ],
        [
            Paragraph("<b>Q: How do merchant purchase redirects work?</b><br/>"
                      "<b>A:</b> When tapping 'Buy from Amazon' or 'Buy from Flipkart', the app uses <code>url_launcher</code> to open the merchant portal with attached affiliate tracking identifiers (e.g. <code>shopwave-21</code>), ensuring proper attribution.", body_style)
        ],
        [
            Paragraph("<b>Q: What Gemini model is used and what is the latency?</b><br/>"
                      "<b>A:</b> The system utilizes <code>gemini-2.5-flash</code> via asynchronous HTTP connection. Typical response latency is between 1.2 to 2.2 seconds, with automatic deterministic fallback if a network timeout occurs.", body_style)
        ],
    ]
    faq_table = Table(faq_data, colWidths=[505])
    faq_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, -1), c_light),
        ('BOX', (0, 0), (-1, -1), 1, c_border),
        ('INNERGRID', (0, 0), (-1, -1), 0.5, c_border),
        ('PADDING', (0, 0), (-1, -1), 6),
    ]))
    story.append(faq_table)

    # Build Document
    doc.build(story, canvasmaker=NumberedCanvas)
    print(f"PDF successfully generated: {PDF_FILE}")

if __name__ == '__main__':
    build_pdf()
