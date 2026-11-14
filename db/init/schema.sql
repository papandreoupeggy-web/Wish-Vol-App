-- Wish Vol App : σχήμα βάσης δεδομένων (PostgreSQL) Datadase Schema bases on the external CRM system for the Users Table
--Programming langue PostgreSQL

-- Create Sequences for customized ids for columns that it's need it e.c. VOL00001
CREATE SEQUENCE user_seq;
CREATE SEQUENCE category_seq;
CREATE SEQUENCE post_seq;
CREATE SEQUENCE request_seq;
CREATE SEQUENCE chat_seq;
CREATE SEQUENCE message_seq;
CREATE SEQUENCE notification_seq;

-- Create Domains for lists with default options when it's need it
CREATE DOMAIN region_t AS varchar(40)
CHECK (VALUE IN (
    'ΑΓΙΟ ΟΡΟΣ',
    'ΑΙΤΩΛΟΑΚΑΡΝΑΝΙΑ',
    'ΑΝΑΤΟΛΙΚΗ ΑΤΤΙΚΗ',
    'ΑΡΓΟΛΙΔΑ',
    'ΑΡΚΑΔΙΑ',
    'ΑΡΤΑ',
    'ΑΧΑΙΑ',
    'ΒΟΙΩΤΙΑ',
    'ΒΟΡΕΙΟΣ ΤΟΜΕΑΣ ΑΘΗΝΩΝ',
    'ΓΡΕΒΕΝΑ',
    'ΔΡΑΜΑ',
    'ΔΥΤΙΚΗ ΑΤΤΙΚΗ',
    'ΔΥΤΙΚΟΣ ΤΟΜΕΑΣ ΑΘΗΝΩΝ',
    'ΔΩΔΕΚΑΝΗΣΑ',
    'ΕΒΡΟΣ',
    'ΕΥΒΟΙΑ',
    'ΕΥΡΥΤΑΝΙΑ',
    'ΖΑΚΥΝΘΟΣ',
    'ΗΛΕΙΑ',
    'ΗΜΑΘΙΑ',
    'ΗΡΑΚΛΕΙΟ',
    'ΘΕΣΠΡΩΤΙΑ',
    'ΘΕΣΣΑΛΟΝΙΚΗ',
    'ΙΩΑΝΝΙΝΑ',
    'ΚΑΒΑΛΑ',
    'ΚΑΡΔΙΤΣΑ',
    'ΚΑΣΤΟΡΙΑ',
    'ΚΕΝΤΡΙΚΟΣ ΤΟΜΕΑΣ ΑΘΗΝΩΝ',
    'ΚΕΡΚΥΡΑ',
    'ΚΕΦΑΛΟΝΙΑ',
    'ΚΙΛΚΙΣ',
    'ΚΟΖΑΝΗ',
    'ΚΟΡΙΝΘΙΑ',
    'ΚΥΚΛΑΔΕΣ',
    'ΛΑΚΩΝΙΑ',
    'ΛΑΡΙΣΑ',
    'ΛΑΣΙΘΙ',
    'ΛΕΣΒΟΣ',
    'ΛΕΥΚΑΔΑ',
    'ΜΑΓΝΗΣΙΑ',
    'ΜΕΣΣΗΝΙΑ',
    'ΝΗΣΟΙ ΑΤΤΙΚΗΣ',
    'ΝΟΤΙΟΣ ΤΟΜΕΑΣ ΑΘΗΝΩΝ',
    'ΞΑΝΘΗ',
    'ΠΕΙΡΑΙΑΣ',
    'ΠΕΛΛΑ',
    'ΠΙΕΡΙΑ',
    'ΠΡΕΒΕΖΑ',
    'ΡΕΘΥΜΝΟ',
    'ΡΟΔΟΠΗ',
    'ΣΑΜΟΣ',
    'ΣΕΡΡΕΣ',
    'ΤΡΙΚΑΛΑ',
    'ΦΘΙΩΤΙΔΑ',
    'ΦΛΩΡΙΝΑ',
    'ΦΩΚΙΔΑ',
    'ΧΑΛΚΙΔΙΚΗ',
    'ΧΑΝΙΑ',
    'ΧΙΟΣ'
));

CREATE DOMAIN occupation_industry_t AS varchar(60)
CHECK (VALUE IN (
    'ΓΕΩΡΓΙΑ & ΠΕΡΙΒΑΛΛΟΝ',
    'ΤΕΧΝΕΣ, ΣΧΕΔΙΟ & ΨΥΧΑΓΩΓΙΑ',
    'ΚΑΤΑΣΚΕΥΕΣ & ΤΕΧΝΙΚΑ ΕΠΑΓΓΕΛΜΑΤΑ',
    'ΕΚΠΑΙΔΕΥΣΗ',
    'ΕΝΕΡΓΕΙΑ & ΥΠΗΡΕΣΙΕΣ ΚΟΙΝΗΣ ΩΦΕΛΕΙΑΣ',
    'ΧΡΗΜΑΤΟΟΙΚΟΝΟΜΙΚΑ & ΛΟΓΙΣΤΙΚΗ',
    'ΚΥΒΕΡΝΗΣΗ & ΔΗΜΟΣΙΑ ΔΙΟΙΚΗΣΗ',
    'ΥΓΕΙΑ & ΠΕΡΙΘΑΛΨΗ',
    'ΦΙΛΟΞΕΝΙΑ & ΤΟΥΡΙΣΜΟΣ',
    'ΑΝΘΡΩΠΙΝΟ ΔΥΝΑΜΙΚΟ & ΔΙΟΙΚΗΣΗ',
    'ΠΛΗΡΟΦΟΡΙΚΗ & ΤΕΧΝΟΛΟΓΙΑ',
    'ΝΟΜΙΚΑ',
    'ΒΙΟΜΗΧΑΝΙΑ & ΠΑΡΑΓΩΓΗ',
    'ΜΑΡΚΕΤΙΝΓΚ & ΜΕΣΑ ΕΝΗΜΕΡΩΣΗΣ',
    'ΜΗ ΚΕΡΔΟΣΚΟΠΙΚΟΙ ΟΡΓΑΝΙΣΜΟΙ',
    'ΑΚΙΝΗΤΗ ΠΕΡΙΟΥΣΙΑ',
    'ΛΙΑΝΙΚΟ ΕΜΠΟΡΙΟ & ΠΩΛΗΣΕΙΣ',
    'ΦΟΙΤΗΤΕΣ / ΣΠΟΥΔΑΣΤΕΣ',
    'ΜΕΤΑΦΟΡΕΣ & ΕΦΟΔΙΑΣΤΙΚΗ ΑΛΥΣΙΔΑ'
));

-- Η διαθεσιμότητα επιτρέπει πολλές τιμές μαζί (π.χ. ΣΑΒΒΑΤΟΚΥΡΙΑΚΑ + ΠΡΩΙΝΕΣ ΩΡΕΣ),
-- γι' αυτό αποθηκεύεται ως πίνακας τιμών (array) με έλεγχο των επιτρεπτών τιμών.
CREATE DOMAIN availability_t AS varchar(40)[]
CHECK (
    cardinality(VALUE) >= 1
    AND VALUE <@ ARRAY[
    'ΚΑΘΗΜΕΡΙΝΕΣ',
    'ΣΑΒΒΑΤΟΚΥΡΙΑΚΑ',
    'ΟΛΕΣ ΤΙΣ ΗΜΕΡΕΣ',
    'ΣΥΓΚΕΚΡΙΜΕΝΕΣ ΗΜΕΡΕΣ',
    'ΠΡΩΙΝΕΣ ΩΡΕΣ',
    'ΜΕΣΗΜΕΡΙΑΝΕΣ ΩΡΕΣ',
    'ΑΠΟΓΕΥΜΑΤΙΝΕΣ ΩΡΕΣ',
    'ΒΡΑΔΙΝΕΣ ΩΡΕΣ',
    'ΠΛΗΡΗΣ ΔΙΑΘΕΣΙΜΟΤΗΤΑ',
    'ΕΥΕΛΙΚΤΟ ΩΡΑΡΙΟ',
    'ΠΕΡΙΟΡΙΣΜΕΝΕΣ ΩΡΕΣ',
    'ΚΑΤΟΠΙΝ ΣΥΝΝΕΟΗΣΗΣ'
    ]::varchar[]
);

-- TABLE USERS
CREATE TABLE users (
    user_id               varchar(12)  PRIMARY KEY
                          DEFAULT 'VOL'  || lpad(nextval('user_seq')::text, 5, '0'),
    username              varchar(50)  NOT NULL UNIQUE,
    password_hash         varchar(255) NOT NULL,
    must_change_password  boolean      NOT NULL DEFAULT true,
    first_name            varchar(60)  NOT NULL,
    last_name             varchar(60)  NOT NULL,
    salutation_first_name varchar(60)  NOT NULL,
    salutation_last_name  varchar(60)  NOT NULL,
    gender                varchar(20)  NOT NULL,
    birthday              date         NOT NULL CHECK (birthday <= CURRENT_DATE),
    phone                 varchar(20)  NOT NULL,
    other_phone           varchar(20),
    email                 varchar(120) NOT NULL UNIQUE,
    Has_Car               boolean      NOT NULL DEFAULT false, 
    occupation_industry   occupation_industry_t NOT NULL,
    user_type             varchar(20)  NOT NULL DEFAULT 'VOLUNTEER'
                          CHECK (user_type   IN ('VOLUNTEER', 'EMPLOYEE', 'VOLUNTEER MANAGER')),
    street_address        varchar(120) NOT NULL,
    zip_code              integer      NOT NULL CHECK (zip_code BETWEEN 10000 AND 99999),
    city                  varchar(60)  NOT NULL,
    region                region_t     NOT NULL,
    user_availability          availability_t NOT NULL,
    activation_status     boolean      NOT NULL DEFAULT true,
    user_start_date       date         NOT NULL,
    created_at            timestamptz  NOT NULL DEFAULT now()
);

-- Η ηλικία δεν αποθηκεύεται (θα ήταν λάθος την επόμενη μέρα γενεθλίων):
-- υπολογίζεται από το birthday. Η προβολή τη δίνει έτοιμη.
CREATE VIEW users_overview AS
SELECT u.*, date_part('year', age(CURRENT_DATE, u.birthday))::int AS age
FROM users u;

-- TABLE CATEGORIES
CREATE TABLE categories (
    category_id    varchar(12)  PRIMARY KEY
                   DEFAULT 'CAT' || lpad(nextval('category_seq')::text, 5, '0'),
    category_title varchar(80)  NOT NULL UNIQUE
);

-- TABLE POSTS
CREATE TABLE posts (
    post_id            varchar(12)  PRIMARY KEY
                       DEFAULT 'POST' || lpad(nextval('post_seq')::text, 5, '0'),
    post_title         varchar(150) NOT NULL,
    post_status        varchar(10)  NOT NULL DEFAULT 'OPEN'
                       CHECK (post_status IN ('OPEN', 'CLOSED')),
    post_city          varchar(60)  NOT NULL,
    user_id            varchar(12)  NOT NULL REFERENCES users(user_id),       -- δημιουργός
    post_description   text         NOT NULL,
    category_id        varchar(12)  NOT NULL REFERENCES categories(category_id),
    participant_number integer      NOT NULL CHECK (participant_number > 0),  -- capacity
    post_region        region_t     NOT NULL,
    child_name         varchar(100) NOT NULL,
    child_age          integer      NOT NULL CHECK (child_age BETWEEN 0 AND 25),
    child_illness      text         NOT NULL,
    post_date          date         NOT NULL,                                 -- ημερομηνία δράσης
    post_time          time         NOT NULL,                                 -- ώρα δράσης
    created_at         timestamptz  NOT NULL DEFAULT now()                    -- πότε αναρτήθηκε
);

-- TABLE REQUESTS
CREATE TABLE requests (
    request_id     varchar(12) PRIMARY KEY
                   DEFAULT 'REQ' || lpad(nextval('request_seq')::text, 5, '0'),
    post_id        varchar(12) NOT NULL REFERENCES posts(post_id),
    user_id        varchar(12) NOT NULL REFERENCES users(user_id),
    request_status varchar(10) NOT NULL DEFAULT 'PENDING'
                   CHECK (request_status IN ('PENDING', 'APPROVED', 'REJECTED')),
    request_date   date        NOT NULL DEFAULT CURRENT_DATE,
    request_time   time        NOT NULL DEFAULT CURRENT_TIME,
    UNIQUE (post_id, user_id)               -- μία αίτηση ανά εθελοντή και post
);

-- TABLE CHAT  (το πολύ ένα chat ανά post)
CREATE TABLE chats (
    chat_id           varchar(12)  PRIMARY KEY
                      DEFAULT 'CHAT' || lpad(nextval('chat_seq')::text, 5, '0'),
    post_id           varchar(12)  NOT NULL UNIQUE REFERENCES posts(post_id),
    chat_name         varchar(120) NOT NULL,
    chat_created_date date         NOT NULL DEFAULT CURRENT_DATE,
    chat_created_by   varchar(12)  NOT NULL REFERENCES users(user_id)
);

-- TABLE CHAT_MEMBERS  (πολλά-προς-πολλά χρήστες–chats)
CREATE TABLE chat_members (
    user_id   varchar(12) NOT NULL REFERENCES users(user_id),
    chat_id   varchar(12) NOT NULL REFERENCES chats(chat_id) ON DELETE CASCADE,
    join_date timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (user_id, chat_id)
);

-- TABLE MESSAGE
CREATE TABLE messages (
    message_id    varchar(12) PRIMARY KEY
                  DEFAULT 'MSG' || lpad(nextval('message_seq')::text, 5, '0'),
    chat_id       varchar(12) NOT NULL REFERENCES chats(chat_id) ON DELETE CASCADE,
    user_id       varchar(12) NOT NULL REFERENCES users(user_id),             -- αποστολέας
    text          text        NOT NULL,
    send_datetime timestamptz NOT NULL DEFAULT now()
);

-- TABLE PUSH NOTIFICATION (πίνακας notifications)
CREATE TABLE notifications (
    notification_id varchar(12) PRIMARY KEY
                    DEFAULT 'NTF' || lpad(nextval('notification_seq')::text, 5, '0'),
    text            text        NOT NULL,
    send_datetime   timestamptz NOT NULL DEFAULT now(),
    user_id         varchar(12) NOT NULL REFERENCES users(user_id)            -- παραλήπτης
);

-- Create Indexex for Forien Keys for easier search via tables
CREATE INDEX idx_posts_user          ON posts(user_id);
CREATE INDEX idx_posts_category      ON posts(category_id);
CREATE INDEX idx_posts_date          ON posts(post_date);
CREATE INDEX idx_requests_user       ON requests(user_id);
CREATE INDEX idx_requests_post       ON requests(post_id);
CREATE INDEX idx_chat_members_chat   ON chat_members(chat_id);
CREATE INDEX idx_messages_chat       ON messages(chat_id, send_datetime);
CREATE INDEX idx_notifications_user  ON notifications(user_id, send_datetime);

-- 12. Συνδέουμε κάθε sequence με τη στήλη του (διαγράφεται μαζί με τον πίνακα)
ALTER SEQUENCE user_seq         OWNED BY users.user_id;
ALTER SEQUENCE category_seq     OWNED BY categories.category_id;
ALTER SEQUENCE post_seq         OWNED BY posts.post_id;
ALTER SEQUENCE request_seq      OWNED BY requests.request_id;
ALTER SEQUENCE chat_seq         OWNED BY chats.chat_id;
ALTER SEQUENCE message_seq      OWNED BY messages.message_id;
ALTER SEQUENCE notification_seq OWNED BY notifications.notification_id;