package com.pingpong.mapper;
import com.pingpong.entity.*;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import java.util.List;

@Mapper
public interface CommonMapper {
    @Select("SELECT * FROM v_event_level")
    List<EventLevelVO> eventLevel();

    @Select("SELECT * FROM v_country_gold")
    List<CountryGoldVO> countryGold();

    @Select("SELECT * FROM v_month_match")
    List<MonthMatchVO> monthMatch();


    @Select("SELECT * FROM v_gender")
    List<GenderVO> gender();

    @Select("SELECT * FROM v_win_rate")
    List<WinRateVO> winRate();

    @Select("SELECT * FROM v_player_native_map")
    List<NativeMapVO> nativeMap();   // 复用 CountryGoldVO 结构

    // 顶部统计：赛事总数、运动员人数、国家/地区数、金牌总数、比赛总场次、本月场次、场均得分
    @Select("SELECT COUNT(*) FROM t_event")
    Integer countEvent();

    @Select("SELECT COUNT(*) FROM t_player")
    Integer countPlayer();

    @Select("SELECT COUNT(DISTINCT country) FROM t_player")
    Integer countCountry();

    @Select("SELECT IFNULL(SUM(gold),0) FROM t_country_medal")
    Integer sumGold();

    @Select("SELECT COUNT(*) FROM t_match")
    Integer countMatch();

    @Select("SELECT COUNT(*) FROM t_match WHERE DATE_FORMAT(match_date,'%Y-%m') = DATE_FORMAT(CURDATE(),'%Y-%m')")
    Integer countMatchThisMonth();

    @Select("SELECT ROUND(AVG(CAST(SUBSTRING_INDEX(score,'-',1) AS UNSIGNED) + CAST(SUBSTRING_INDEX(score,'-',-1) AS UNSIGNED)),1) FROM t_match")
    Double avgScore();

}

