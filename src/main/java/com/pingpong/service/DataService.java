package com.pingpong.service;
import com.pingpong.entity.*;
import com.pingpong.mapper.CommonMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Map;

@Service
public class DataService {
    @Autowired
    private CommonMapper commonMapper;

    public List<EventLevelVO> eventLevel(){return commonMapper.eventLevel();}
    public List<CountryGoldVO> countryGold(){return commonMapper.countryGold();}
    public List<MonthMatchVO> monthMatch(){return commonMapper.monthMatch();}
    public List<GenderVO> gender(){return commonMapper.gender();}
    public List<WinRateVO> winRate(){return commonMapper.winRate();}

    public List<NativeMapVO> nativeMap(){ return commonMapper.nativeMap(); }

    // 统计聚合
    public Map<String,Object> stats(){
        Map<String,Object> m = new java.util.HashMap<>();
        m.put("eventNum",  safeInt(commonMapper.countEvent()));
        m.put("playerNum", safeInt(commonMapper.countPlayer()));
        m.put("countryNum",safeInt(commonMapper.countCountry()));
        m.put("goldSum",   safeInt(commonMapper.sumGold()));
        m.put("matchNum",  safeInt(commonMapper.countMatch()));
        m.put("monthNum",  safeInt(commonMapper.countMatchThisMonth()));
        m.put("avgScore",  safeDouble(commonMapper.avgScore()));
        return m;
    }

    private int safeInt(Integer v){ return v==null?0:v; }
    private double safeDouble(Double v){ return v==null?0.0:v; }

}
