/* 乒乓球数据可视化接口 */
if ($ && $.ajaxSetup) { $.ajaxSetup({ cache: false }); }
$(function () {
    if ($ && $.ajaxSetup) { $.ajaxSetup({ cache: false }); }
    $.getJSON('/api/all', function (r) {
        initEventLevel(r.eventLevel);      // 赛事级别饼图
        initMapChina(r.countryGold);       // 运动员籍贯地图（原国家金牌数据）
        initMonthMatch(r.monthMatch);      // 每月场次折线
        initGender(r.gender);              // 男女比例
        initWinRate(r.winRate);            // 胜率排行
        initCountryGold(r.countryGold);    // 国家金牌榜（原雷达图位置）
        // 顶部统计数字（兼容旧浏览器）
        if (r.stats){
            var s = r.stats || {};
            $('#eventNum').text(s.eventNum != null ? s.eventNum : 0);
            $('#playerNum').text(s.playerNum != null ? s.playerNum : 0);
            $('#countryNum').text(s.countryNum != null ? s.countryNum : 0);
            $('#goldSum').text(s.goldSum != null ? s.goldSum : 0);
            $('#matchNum').text(s.matchNum != null ? s.matchNum : 0);
            $('#monthNum').text(s.monthNum != null ? s.monthNum : 0);
            $('#avgScore').text(s.avgScore != null ? (''+s.avgScore) : '0');
        } else {
            // 兜底：用已有数据估算（无后端统计时）
            $('#eventNum').text((r.eventLevel||[]).reduce((s,d)=>s+(d.value||0),0));
            $('#playerNum').text((r.gender||[]).reduce((s,d)=>s+(d.value||0),0));
            $('#countryNum').text((r.countryGold||[]).length);
            $('#goldSum').text((r.countryGold||[]).reduce((s,d)=>s+(d.gold||0),0));
            $('#matchNum').text((r.monthMatch||[]).reduce((s,d)=>s+(d.num||0),0));
            $('#monthNum').text(((r.monthMatch||[]).slice(-1)[0]||{}).num||0);
            $('#avgScore').text('0');
        }
        $(".loading").fadeOut();           // 数据到达后关闭 loading
    });
});

/* 1. 赛事级别饼图 -> echarts4 */
function initEventLevel(data) {
    var myChart = echarts.init(document.getElementById('echarts4'));
    var option = {
        color: ['#A0CE3A', '#31C5C0', '#1E9BD1', '#0F347B'],
        tooltip: {trigger: 'item', formatter: '{b}: {c} ({d}%)'},
        legend: {bottom: 0, textStyle: {color: '#fff'}},
        series: [{
            type: 'pie',
            radius: ['30%', '50%'],
            data: data
        }]
    };
    myChart.setOption(option);
    window.addEventListener("resize", function () { myChart.resize(); });
}

/* 国家金牌榜 -> 移到原雷达图位置 */
function initCountryGold(data) {
    var myChart = echarts.init(document.getElementById('lastecharts'));
    var axis = data.map(d => d.country);
    var gold = data.map(d => d.gold);
    var option = {
        tooltip: { trigger: 'axis' },
        grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
        xAxis: {
            type: 'category',
            data: axis,
            axisLabel: { color: 'rgba(255,255,255,.7)', rotate: 30 }
        },
        yAxis: { type: 'value', axisLabel: { color: 'rgba(255,255,255,.7)' } },
        series: [{
            data: gold,
            type: 'bar',
            barWidth: '15%',
            itemStyle: {
                color: new echarts.graphic.LinearGradient(0, 0, 0, 1,
                    [{ offset: 0, color: '#f7e80d' }, { offset: 1, color: '#ff5722' }])
            }
        }]
    };
    myChart.setOption(option);
    window.addEventListener("resize", function () { myChart.resize(); });
}
/* 3. 每月比赛场次 -> echarts2 */
function initMonthMatch(data) {
    var myChart = echarts.init(document.getElementById('echarts2'));
    var month = data.map(d => d.month);
    var num = data.map(d => d.num);
    var option = {
        tooltip: {trigger: 'axis'},
        legend: {data: ['场次'], top: 0, textStyle: {color: '#fff'}},
        grid: {left: '3%', right: '4%', bottom: '3%', containLabel: true},
        xAxis: {
            type: 'category',
            boundaryGap: false,
            data: month,
            axisLabel: {color: 'rgba(255,255,255,.7)'}
        },
        yAxis: {type: 'value', axisLabel: {color: 'rgba(255,255,255,.7)'}},
        series: [{
            name: '场次',
            type: 'line',
            smooth: true,
            areaStyle: {
                color: new echarts.graphic.LinearGradient(0, 0, 0, 1,
                    [{offset: 0, color: 'rgba(228,228,126,.8)'}, {offset: 0.8, color: 'rgba(228,228,126,.1)'}])
            },
            data: num
        }]
    };
    myChart.setOption(option);
    window.addEventListener("resize", function () { myChart.resize(); });
}

/* 4. 男女比例 -> pe01 */
function initGender(data) {
    var myChart = echarts.init(document.getElementById('pe01'));
    var total = data.reduce((s, d) => s + d.value, 0);
    var option = {
        tooltip: {trigger: 'item', formatter: '{b}: {c} ({d}%)'},
        series: [{
            type: 'pie',
            radius: ['50%', '70%'],
            avoidLabelOverlap: false,
            label: {show: true, position: 'center', formatter: '男/女\n' + total + '人', color: '#fff'},
            labelLine: {show: false},
            data: data
        }]
    };
    myChart.setOption(option);
    window.addEventListener("resize", function () { myChart.resize(); });
}

/* 5. 胜率排行榜 -> 替换原 .paim */
function initWinRate(data) {
    var $ul = $('.paim ul').empty();
    data.forEach((d, i) => {
        var rate = d.winRate.toFixed(1);
        $ul.append(
            `<li>
              <span>${i + 1}</span>
              <div class="pmnav">
                <p>${d.playerName}（${d.country}）</p>
                <div class="pmbar">
                  <span style="width:${rate}%"></span>
                  <i>${rate}%</i>
                </div>
              </div>
            </li>`);
    });

}

/* 运动员籍贯分布地图 -> 使用新接口 /api/nativeMap */
function initMapChina() {
    $.getJSON('/api/nativeMap', function (data) {   // ← 改这里
        var myChart = echarts.init(document.getElementById('echarts1'));
        var mapData = data.map(d => ({ name: d.name, value: d.value }));
        var option = {
            tooltip: { trigger: 'item', formatter: '{b}: {c}' },
            visualMap: {
                min: 0,
                max: (mapData.length? Math.max(...mapData.map(d => d.value)) : 0),
                left: 'left', top: '20px',
                text: ['多', '少'], calculable: true,
                inRange: { color: ['#e0ffff', '#006edd'] },
                textStyle: { color: 'black' }
            },
            series: [{
                name: '运动员籍贯',
                type: 'map',
                mapType: 'china',
                roam: false,
                label: { show: true, color: 'rgba(255,255,255,0.7)' },
                itemStyle: { borderColor: 'rgba(255,255,255,0.2)' },
                emphasis: {
                    label: { color: '#fff' },
                    itemStyle: { areaColor: '#f7e80d' }
                },
                data: mapData
            }]
        };
        myChart.setOption(option);
        window.addEventListener("resize", () => myChart.resize());
    });
}

