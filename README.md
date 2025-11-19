# 乒乓球国际赛事数据可视化系统

这是一个基于 ECharts 和 Spring Boot 构建的数据可视化项目，旨在动态展示乒乓球国际赛事的各项数据统计。

## ✨ 项目截图

[可视化.png](https://github.com/Dvesiz/pingpong-dashboard/blob/main/%E5%8F%AF%E8%A7%86%E5%8C%96.png)


## 🚀 主要功能

- **实时数据显示**: 顶部面板实时展示赛事总数、运动员人数、覆盖国家/地区、金牌总数、比赛总场次、本月场次和场均得分。
- **多维度图表分析**:
    - **赛事级别分布**: 使用环形图展示不同级别赛事（如 WorldCup, Olympic, WorldChamp）的比例。
    - **运动员籍贯分布**: 在中国地图上高亮显示运动员的籍贯地分布。
    - **国家金牌榜**: 使用条形图展示各个国家/地区的金牌数量排名。
    - **每月比赛场次**: 使用折线图展示随时间变化的比赛频次。
    - **男女比例**: 使用饼图清晰地展示男女运动员的比例。
    - **胜率排行榜**: 动态滚动的列表展示胜率最高的运动员。

## 🛠️ 技术栈

- **后端**:
    - **Spring Boot**: 核心应用框架。
    - **MyBatis**: 数据持久层框架，用于与数据库交互。
    - **Maven**: 项目管理和构建工具。
- **前端**:
    - **HTML5 & CSS3**: 网页结构与样式。
    - **JavaScript (jQuery)**: 核心前端逻辑与 DOM 操作。
    - **ECharts**: 功能强大的数据可视化图表库。
- **数据库**:
    - **MySQL**: 关系型数据库，用于存储所有赛事数据。

## ⚙️ 如何运行

1.  **环境准备**:
    - `JDK 17` 或更高版本。
    - `Maven 3.x` 或更高版本。
    - `MySQL 8.x` 或更高版本。

2.  **数据库设置**:
    - 创建一个名为 `pingpong_db` (或您在 `application.yml` 中配置的名称) 的数据库。
    - 将项目中的 SQL 脚本导入到您的数据库中以创建表和插入初始数据。

3.  **配置项目**:
    - 修改 `src/main/resources/application.yml` 文件，更新 `spring.datasource` 下的数据库连接信息（URL、用户名、密码）。

    ```yaml
    spring:
      datasource:
        url: jdbc:mysql://localhost:3306/pingpong?serverTimezone=UTC
        username: your_username
        password: your_password
        driver-class-name: com.mysql.cj.jdbc.Driver
    ```

4.  **启动后端服务**:
    - **方法一：使用 Maven 命令**
      在项目根目录下打开终端，运行以下命令：
      ```bash
      ./mvnw spring-boot:run
      ```
    - **方法二：使用 IDE**
      直接运行 `src/main/java/com/pingpong/Application.java` 文件中的 `main` 方法。

5.  **访问前端页面**:
    - 打开浏览器，访问 `http://localhost:8080/index.html`。
    - 如果一切正常，您将看到数据可视化仪表盘。
