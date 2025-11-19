/* =========================================================
 *  乒乓球国际赛事数据库 ‑ 完整版（重整）
 *  DB：pingpong_db
 *  字符集：utf8mb4
 * ========================================================= */
CREATE DATABASE IF NOT EXISTS pingpong_db DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE pingpong_db;

/* =========================================================
 *  1. 维度表
 * ========================================================= */
DROP TABLE IF EXISTS t_event;
CREATE TABLE t_event (
                         id          INT PRIMARY KEY AUTO_INCREMENT,
                         event_name  VARCHAR(120) NOT NULL COMMENT '赛事名称',
                         hold_date   DATE         NOT NULL COMMENT '举办日期',
                         venue       VARCHAR(120) COMMENT '举办城市/国家',
                         event_level ENUM('WorldChamp','WorldCup','ITTF','Olympic') DEFAULT 'ITTF'
) ENGINE=InnoDB COMMENT='赛事维度表';

DROP TABLE IF EXISTS t_player;
CREATE TABLE t_player (
                          id               INT PRIMARY KEY AUTO_INCREMENT,
                          player_name      VARCHAR(60) NOT NULL,
                          country          VARCHAR(60) NOT NULL,
                          gender           ENUM('M','F') DEFAULT 'M',
                          birth_date       DATE,
                          native_province  VARCHAR(30) COMMENT '籍贯（中国选手）'
) ENGINE=InnoDB COMMENT='运动员维度表';

DROP TABLE IF EXISTS t_country_medal;
CREATE TABLE t_country_medal (
                                 country VARCHAR(60) PRIMARY KEY,
                                 gold    INT DEFAULT 0,
                                 silver  INT DEFAULT 0,
                                 bronze  INT DEFAULT 0
) ENGINE=InnoDB COMMENT='国家奖牌汇总（冗余加速）';

/* =========================================================
 *  2. 事实表
 * ========================================================= */
DROP TABLE IF EXISTS t_match;
CREATE TABLE t_match (
                         id          BIGINT PRIMARY KEY AUTO_INCREMENT,
                         event_id    INT NOT NULL,
                         player_a_id INT NOT NULL,
                         player_b_id INT NOT NULL,
                         win_id      INT NOT NULL COMMENT '胜者ID',
                         score       VARCHAR(60) COMMENT '如 4:2',
                         match_date  DATETIME DEFAULT CURRENT_TIMESTAMP,
                         INDEX idx_event (event_id),
                         CONSTRAINT fk_match_event  FOREIGN KEY (event_id)    REFERENCES t_event(id),
                         CONSTRAINT fk_match_p_a    FOREIGN KEY (player_a_id) REFERENCES t_player(id),
                         CONSTRAINT fk_match_p_b    FOREIGN KEY (player_b_id) REFERENCES t_player(id),
                         CONSTRAINT fk_match_win    FOREIGN KEY (win_id)      REFERENCES t_player(id)
) ENGINE=InnoDB COMMENT='每一场对决';

/* =========================================================
 *  3. 初始化数据
 * ========================================================= */
INSERT INTO t_event(id,event_name,hold_date,venue,event_level) VALUES
                                                                   (1,'2020威海男/女世界杯','2020-11-13','中国威海','WorldCup'),
                                                                   (2,'2021东京奥运乒乓赛','2021-07-24','日本东京','Olympic'),
                                                                   (3,'2021休斯顿世乒赛','2021-11-23','美国休斯顿','WorldChamp'),
                                                                   (4,'2022新加坡大满贯','2022-03-11','新加坡','ITTF'),
                                                                   (5,'2022成都世乒赛团体','2022-09-30','中国成都','WorldChamp'),
                                                                   (6,'2023德班世乒赛','2023-05-20','南非德班','WorldChamp'),
                                                                   (7,'2023澳门冠军赛','2023-10-16','中国澳门','ITTF'),
                                                                   (8,'2024巴黎奥运乒乓赛','2024-07-27','法国巴黎','Olympic');

INSERT INTO t_player(id,player_name,country,gender,birth_date,native_province) VALUES
                                                                                   (1,'樊振东','中国','M','1997-01-22','广东'),
                                                                                   (2,'马龙','中国','M','1988-10-20','辽宁'),
                                                                                   (3,'王楚钦','中国','M','2000-05-11','吉林'),
                                                                                   (4,'张本智和','日本','M','2003-06-27',NULL),
                                                                                   (5,'林昀儒','中国台北','M','2001-08-17',NULL),
                                                                                   (6,'奥恰洛夫','德国','M','1988-09-02',NULL),
                                                                                   (7,'波尔','德国','M','1981-03-08',NULL),
                                                                                   (8,'莫雷高德','瑞典','M','2002-02-16',NULL),
                                                                                   (9,'雨果·卡尔德拉诺','巴西','M','1996-06-22',NULL),
                                                                                   (10,'张禹珍','韩国','M','1997-08-21',NULL),
                                                                                   (11,'孙颖莎','中国','F','2000-11-04','河北'),
                                                                                   (12,'陈梦','中国','F','1994-01-15','山东'),
                                                                                   (13,'王曼昱','中国','F','1999-02-09','黑龙江'),
                                                                                   (14,'王艺迪','中国','F','1997-02-14','辽宁'),
                                                                                   (15,'早田希娜','日本','F','2000-07-07',NULL),
                                                                                   (16,'伊藤美诚','日本','F','2000-10-21',NULL),
                                                                                   (17,'平野美宇','日本','F','2000-04-14',NULL),
                                                                                   (18,'韩莹','德国','F','1983-04-29',NULL),
                                                                                   (19,'波尔卡诺娃','奥地利','F','1994-09-14',NULL),
                                                                                   (20,'冯天薇','新加坡','F','1986-08-31',NULL);

INSERT INTO t_country_medal(country,gold,silver,bronze) VALUES
                                                            ('中国',15,6,3),('日本',3,4,6),('德国',2,3,4),('瑞典',1,1,1),
                                                            ('巴西',1,0,2),('韩国',0,2,3),('中国台北',0,1,1),('奥地利',0,1,0),
                                                            ('新加坡',0,0,2),('法国',0,0,1);

/* =========================================================
 *  4. 生成 100 场示范比赛（40 内战 + 60 外战）
 * ========================================================= */
INSERT INTO t_match(event_id,player_a_id,player_b_id,win_id,score,match_date)
SELECT
    1+FLOOR(RAND()*8),
    1+FLOOR(RAND()*10),   -- 中国 1-10
    1+FLOOR(RAND()*10),
    CASE WHEN RAND()>0.5 THEN 1+FLOOR(RAND()*10) ELSE 1+FLOOR(RAND()*10) END,
    ELT(1+FLOOR(RAND()*5),'4-0','4-1','4-2','4-3','3-2'),
    DATE_ADD('2020-01-01', INTERVAL FLOOR(RAND()*1800) DAY)
FROM (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t1,
     (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t2;

INSERT INTO t_match(event_id,player_a_id,player_b_id,win_id,score,match_date)
SELECT
    1+FLOOR(RAND()*8),
    1+FLOOR(RAND()*20),   -- 全体 20 人
    1+FLOOR(RAND()*20),
    CASE WHEN RAND()>0.5 THEN 1+FLOOR(RAND()*20) ELSE 1+FLOOR(RAND()*20) END,
    ELT(1+FLOOR(RAND()*5),'4-0','4-1','4-2','4-3','3-2'),
    DATE_ADD('2020-01-01', INTERVAL FLOOR(RAND()*1800) DAY)
FROM (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) t1,
     (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t2;

/* 保证只留 100 行 */
DELETE FROM t_match WHERE id > 100;

/* =========================================================
 *  5. 分析视图
 * ========================================================= */
CREATE OR REPLACE VIEW v_event_level AS
SELECT event_level AS name, COUNT(*) AS value
FROM t_event
GROUP BY event_level;

CREATE OR REPLACE VIEW v_country_gold AS
SELECT country, SUM(gold) AS gold
FROM t_country_medal
GROUP BY country
ORDER BY gold DESC
LIMIT 10;

CREATE OR REPLACE VIEW v_month_match AS
SELECT DATE_FORMAT(match_date,'%Y-%m') AS month, COUNT(*) AS num
FROM t_match
GROUP BY month
ORDER BY month;

CREATE OR REPLACE VIEW v_gender AS
SELECT gender AS name, COUNT(*) AS value
FROM t_player
GROUP BY gender;

CREATE OR REPLACE VIEW v_win_rate AS
SELECT
    p.player_name AS playerName,
    p.country,
    ROUND(IFNULL(SUM(CASE WHEN m.win_id = p.id THEN 1 ELSE 0 END) * 100.0 / COUNT(m.id), 0), 1) AS winRate
FROM t_player p
         LEFT JOIN t_match m ON p.id = m.player_a_id OR p.id = m.player_b_id
GROUP BY p.id
ORDER BY winRate DESC
LIMIT 10;

/* =========================================================
 *  6. 地图专用：籍贯分布
 * ========================================================= */
CREATE OR REPLACE VIEW v_player_native_map AS
SELECT native_province AS name,
       COUNT(*)        AS value
FROM t_player
WHERE native_province IS NOT NULL
GROUP BY native_province;

/* =========================================================
 *  7. 后续扩展建议
 *  1) 把 native_province 拆成 t_province 维度表，避免硬编码。
 *  2) 增加 t_match_game 记录每小分，方便更细粒度的技战术分析。
 *  3) 用存储过程定时刷新 t_country_medal，避免手动维护。
 * ========================================================= */
