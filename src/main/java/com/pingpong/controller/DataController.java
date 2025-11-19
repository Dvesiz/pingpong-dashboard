package com.pingpong.controller;
import com.pingpong.entity.*;
import com.pingpong.service.DataService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@CrossOrigin
@RequestMapping("/api")
public class DataController {
    @Autowired
    private DataService dataService;

    @GetMapping("/eventLevel")
    public List<EventLevelVO> eventLevel(){return dataService.eventLevel();}

    @GetMapping("/countryGold")
    public List<CountryGoldVO> countryGold(){return dataService.countryGold();}

    @GetMapping("/monthMatch")
    public List<MonthMatchVO> monthMatch(){return dataService.monthMatch();}

    @GetMapping("/gender")
    public List<GenderVO> gender(){return dataService.gender();}

    @GetMapping("/winRate")
    public List<WinRateVO> winRate(){return dataService.winRate();}

    /* 赛事能力雷达 = 金牌分布 5 维示例 */
    @GetMapping("/radar")
    public Map<String,Object> radar(){
        List<CountryGoldVO> list = dataService.countryGold();
        // 取前5国当5维
        List<Map<String,Object>> indicator = new ArrayList<>();
        List<Integer>          value     = new ArrayList<>();
        list.stream().limit(5).forEach(c->{
            indicator.add(Map.of("name",c.getCountry(),"max",20));
            value.add(c.getGold());
        });
        return Map.of("indicator",indicator,"value",value);
    }


    /* 大屏需要合并的“大 JSON”可再包一层 */
    @GetMapping("/all")
    public Map<String,Object> all(){
        Map<String,Object> m=new HashMap<>();
        m.put("eventLevel",dataService.eventLevel());
        m.put("countryGold",dataService.countryGold());
        m.put("monthMatch",dataService.monthMatch());
        m.put("gender",dataService.gender());
        m.put("winRate",dataService.winRate());
        m.put("stats",dataService.stats());
        return m;
    }

    @GetMapping("/nativeMap")
    public List<NativeMapVO> nativeMap(){ return dataService.nativeMap(); }

    @GetMapping("/stats")
    public Map<String,Object> stats(){ return dataService.stats(); }

}
