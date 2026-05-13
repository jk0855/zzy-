<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover">
    <title>美食厨房 - 私房菜空间</title>
    <!-- 引入Font Awesome 6 (免费图标库) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            -webkit-tap-highlight-color: transparent;
        }

        body {
            background-color: #f5f5f5;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
        }

        /* 移动端容器 */
        .app-container {
            width: 100%;
            max-width: 450px;
            height: 780px;
            background-color: white;
            border-radius: 32px;
            box-shadow: 0 0 30px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            position: relative;
            display: flex;
            flex-direction: column;
        }

        /* 主内容区域 - 滚动 */
        .main-content {
            flex: 1;
            overflow-y: auto;
            padding: 20px 16px 80px 16px;
            scroll-behavior: smooth;
        }

        /* 自定义滚动条 */
        .main-content::-webkit-scrollbar {
            width: 4px;
        }
        .main-content::-webkit-scrollbar-track {
            background: #f1f1f1;
        }
        .main-content::-webkit-scrollbar-thumb {
            background: #ccc;
            border-radius: 4px;
        }

        /* 页面切换 */
        .page {
            display: none;
            animation: fadeIn 0.2s ease;
        }
        .page.active-page {
            display: block;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(5px);}
            to { opacity: 1; transform: translateY(0);}
        }

        /* 底部导航栏 */
        .bottom-nav {
            background: rgba(255,255,255,0.96);
            backdrop-filter: blur(10px);
            border-top: 1px solid #f0f0f0;
            display: flex;
            justify-content: space-around;
            align-items: center;
            padding: 10px 16px 14px;
            box-shadow: 0 -2px 12px rgba(0,0,0,0.02);
        }
        .nav-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 4px;
            font-size: 12px;
            color: #999;
            transition: color 0.2s;
            cursor: pointer;
            flex: 1;
        }
        .nav-item i {
            font-size: 22px;
        }
        .nav-item.active {
            color: #ff7b2c;
            font-weight: 500;
        }
        .nav-item span {
            font-size: 11px;
        }

        /* 公用卡片样式 */
        .card {
            background: white;
            border-radius: 20px;
            padding: 16px;
            margin-bottom: 16px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.04);
            border: 1px solid #f0f0f0;
        }
        .flex-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
        }
        .grid-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
        }
        .badge-icon {
            background: #fff1e6;
            padding: 8px 12px;
            border-radius: 30px;
            font-size: 13px;
            color: #ff7b2c;
            font-weight: 500;
        }
        button, .btn-like {
            background: #ff7b2c;
            border: none;
            color: white;
            padding: 8px 16px;
            border-radius: 40px;
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;
            transition: 0.2s;
        }
        button:active, .btn-like:active {
            background: #e66312;
            transform: scale(0.97);
        }
        .btn-outline {
            background: white;
            border: 1px solid #ff7b2c;
            color: #ff7b2c;
        }
        .btn-outline:active {
            background: #fff1e6;
        }
        .section-title {
            font-weight: 700;
            font-size: 18px;
            margin-bottom: 12px;
            display: flex;
            justify-content: space-between;
            align-items: baseline;
        }
        .tag-group {
            display: flex;
            gap: 12px;
            background: #f8f8f8;
            padding: 6px;
            border-radius: 60px;
            margin: 12px 0;
        }
        .tag {
            flex: 1;
            text-align: center;
            padding: 8px 0;
            border-radius: 40px;
            font-size: 14px;
            font-weight: 500;
            color: #666;
            cursor: pointer;
        }
        .tag.active-tag {
            background: #ff7b2c;
            color: white;
            box-shadow: 0 2px 6px rgba(255,123,44,0.2);
        }
        .empty-state {
            text-align: center;
            padding: 48px 20px;
            background: #fefaf7;
            border-radius: 24px;
            margin: 16px 0;
            color: #bcafa2;
        }
        .menu-categories {
            display: flex;
            gap: 12px;
            margin-top: 20px;
            justify-content: space-between;
        }
        .cat-item {
            flex: 1;
            background: #f8f8f8;
            text-align: center;
            padding: 12px 4px;
            border-radius: 40px;
            font-size: 14px;
            font-weight: 500;
            color: #333;
        }
        .dish-item {
            background: #faf7f2;
            border-radius: 16px;
            padding: 12px;
        }
        hr {
            margin: 12px 0;
            border: none;
            border-top: 1px solid #efefef;
        }
        .stat-row {
            display: flex;
            justify-content: space-around;
            text-align: center;
            background: #fef7f0;
            border-radius: 28px;
            padding: 12px 0;
            margin: 16px 0;
        }
        .stat-item {
            flex: 1;
        }
        .stat-num {
            font-size: 20px;
            font-weight: 800;
            color: #ff7b2c;
        }
        .list-menu-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px 0;
            border-bottom: 1px solid #f0f0f0;
        }
        .list-menu-item:last-child {
            border-bottom: none;
        }
        .avatar {
            width: 52px;
            height: 52px;
            background: #ffe0cc;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ff7b2c;
            font-size: 24px;
        }
        .inline-icon {
            margin-right: 8px;
            color: #ff7b2c;
        }
        .order-header {
            display: flex;
            align-items: baseline;
            justify-content: space-between;
        }
        .notice-badge {
            background: #ffeee5;
            border-radius: 50px;
            padding: 6px 12px;
            font-size: 12px;
            color: #ff7b2c;
        }
        .green-dot {
            color: #4caf50;
            font-size: 10px;
        }
        .signin-card {
            background: linear-gradient(135deg, #fff6ea, #fff0e1);
        }
        .random-dish {
            background: #fef3e8;
            border-radius: 24px;
            padding: 16px;
        }
        .text-small {
            font-size: 12px;
            color: #8e8e93;
        }
        i.fa, i.far, i.fas {
            margin-right: 4px;
        }
        .discover-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
            margin: 16px 0;
        }
        .discover-card {
            background: #fff9f2;
            border-radius: 20px;
            padding: 14px;
            border: 1px solid #ffe1c4;
        }
        .point-number {
            font-weight: bold;
            font-size: 20px;
            margin-right: 4px;
        }
    </style>
</head>
<body>
<div class="app-container">
    <div class="main-content" id="mainContent">
        <!-- 厨房主页 (页面1) -->
        <div id="kitchenPage" class="page active-page">
            <!-- 顶部 75 积分 / 标题 -->
            <div class="flex-row" style="margin-bottom: 8px;">
                <div style="display: flex; align-items: center; gap: 8px;">
                    <i class="fas fa-utensils" style="color:#ff7b2c; font-size: 24px;"></i>
                    <span style="font-weight: 700; font-size: 20px;">用户S7Vo8EWE的厨房</span>
                </div>
                <div class="badge-icon">
                    <i class="fas fa-coins"></i> 75
                </div>
            </div>
            <p style="color: #a6a6a6; margin-bottom: 24px; font-size: 13px;">
                <i class="fas fa-sun"></i> 生活再忙，别错过美食与阳光
            </p>
            <!-- 三个主要操作卡片 -->
            <div class="grid-2" style="grid-template-columns: 1fr 1fr 1fr; gap: 12px; margin-bottom: 20px;">
                <div class="dish-item" style="text-align: center; background: #fff3e9;" onclick="alert('私房菜 · 独门秘制美味')">
                    <i class="fas fa-crown" style="font-size: 24px; color:#ff9f4a;"></i>
                    <div style="font-weight: 600; margin-top: 6px;">私房菜</div>
                </div>
                <div class="dish-item" style="text-align: center; background: #fff3e9;" onclick="alert('邀友点菜 · 邀请朋友一起来点餐')">
                    <i class="fas fa-user-friends" style="font-size: 24px; color:#ff9f4a;"></i>
                    <div style="font-weight: 600; margin-top: 6px;">邀友点菜</div>
                </div>
                <div class="dish-item" style="text-align: center; background: #ffede1;" onclick="alert('打开管理菜单，开始添加你的美食')">
                    <i class="fas fa-sliders-h" style="font-size: 24px; color:#ff7b2c;"></i>
                    <div style="font-weight: 600; margin-top: 6px;">管理菜单</div>
                </div>
            </div>

            <!-- 全部分类标签 全部 / 热菜 / 凉菜 -->
            <div class="tag-group">
                <div class="tag active-tag" onclick="switchFoodTag(this, '全部')">全部</div>
                <div class="tag" onclick="switchFoodTag(this, '热菜')">热菜</div>
                <div class="tag" onclick="switchFoodTag(this, '凉菜')">凉菜</div>
            </div>

            <!-- 暂无菜品区域 -->
            <div class="empty-state" id="emptyDishArea">
                <i class="fas fa-utensil-spoon" style="font-size: 38px; margin-bottom: 12px; display: block; color:#d9cfbf;"></i>
                <p style="margin-bottom: 12px;">暂无菜品</p>
                <button class="btn-outline" style="background: white;" onclick="alert('点击「管理菜单」开始添加你的美食～')">➕ 添加美食</button>
                <p class="text-small" style="margin-top: 12px;">点击「管理菜单」按钮开始添加你的美食</p>
            </div>

            <!-- 汤品 主食 甜品 饮品 -->
            <div class="menu-categories">
                <div class="cat-item"><i class="fas fa-mug-hot"></i> 汤品</div>
                <div class="cat-item"><i class="fas fa-bread-slice"></i> 主食</div>
                <div class="cat-item"><i class="fas fa-cake-candles"></i> 甜品</div>
                <div class="cat-item"><i class="fas fa-wine-bottle"></i> 饮品</div>
            </div>
        </div>

        <!-- 订单页面 (页面2) -->
        <div id="orderPage" class="page">
            <div class="order-header">
                <h2 style="font-size: 24px; font-weight: 700;">厨房订单 <i class="fas fa-chevron-down" style="font-size: 16px;"></i></h2>
                <span class="notice-badge"><i class="fas fa-bell"></i> 通知 +1</span>
            </div>
            <p style="margin: 8px 0 20px 0; color: #666;"><i class="fas fa-receipt"></i> 一共记录了0个厨房订单</p>
            <div class="card flex-row" style="justify-content: space-between;">
                <span><i class="fas fa-clock"></i> 订单通知服务</span>
                <span class="notice-badge">(+1) <i class="fas fa-angle-right"></i></span>
            </div>
            <div class="card flex-row" style="margin-bottom: 24px;" onclick="alert('积分明细：当前积分75，可兑换好礼')">
                <span><i class="fas fa-coins"></i> 积分明细</span>
                <i class="fas fa-arrow-right"></i>
            </div>
            <!-- 暂无历史订单 -->
            <div class="empty-state" style="background: #fcf9f6;">
                <i class="far fa-file-alt" style="font-size: 44px; color: #ddd1c4;"></i>
                <p style="margin: 12px 0; font-weight: 500;">暂无历史订单</p>
                <button class="btn-like" id="goToKitchenBtn" onclick="switchTab('kitchen')">🍽️ 去点餐</button>
            </div>
        </div>

        <!-- 发现页面 (页面3) -->
        <div id="discoverPage" class="page">
            <h2 style="font-size: 26px; font-weight: 700; margin-bottom: 12px;">发现</h2>
            <!-- 菜谱广场主卡片 -->
            <div class="card" style="background: linear-gradient(145deg, #fff9f2, #fff6ec); border: none;">
                <div class="flex-row">
                    <div><i class="fas fa-book-open" style="font-size: 24px; color:#ff7b2c;"></i> <strong style="font-size: 18px;">菜谱广场</strong></div>
                    <i class="fas fa-chevron-right"></i>
                </div>
                <p class="text-small" style="margin-top: 6px;">海量现成菜谱，随心挑选，一键加入厨房</p>
            </div>
            <!-- 2x2 四宫格: 家常录 / 家乡美食 / 我的美食记录 / 分享家乡味道 -->
            <div class="discover-grid">
                <div class="discover-card" onclick="alert('家常录 · 平凡日子的烟火气')">
                    <i class="fas fa-home" style="font-size: 24px; color:#ff9f6e;"></i>
                    <div style="font-weight: 700; margin: 8px 0 4px;">家常录</div>
                    <div class="flex-row"><span class="text-small">温暖小炒集</span><span class="badge-icon" style="background: white;">去看看</span></div>
                </div>
                <div class="discover-card" onclick="alert('家乡美食 · 舌尖上的乡愁')">
                    <i class="fas fa-map-marker-alt" style="font-size: 24px; color:#ff9f6e;"></i>
                    <div style="font-weight: 700; margin: 8px 0 4px;">家乡美食</div>
                    <div class="flex-row"><span class="text-small">地道风味</span><span class="badge-icon" style="background: white;">去看看</span></div>
                </div>
                <div class="discover-card" onclick="alert('我的美食记录 · 珍藏你的美味瞬间')">
                    <i class="fas fa-camera" style="font-size: 24px; color:#ff9f6e;"></i>
                    <div style="font-weight: 700; margin: 8px 0 4px;">我的美食记录</div>
                    <div class="flex-row"><span class="text-small">记录美好食光</span><span class="badge-icon" style="background: white;">去看看</span></div>
                </div>
                <div class="discover-card" onclick="alert('分享家乡味道 · 让更多人品尝你家味道')">
                    <i class="fas fa-share-alt" style="font-size: 24px; color:#ff9f6e;"></i>
                    <div style="font-weight: 700; margin: 8px 0 4px;">分享家乡味道</div>
                    <div class="flex-row"><span class="text-small">传递家香</span><span class="badge-icon" style="background: white;">去看看</span></div>
                </div>
            </div>

            <!-- 每日签到模块 -->
            <div class="card signin-card" style="margin-top: 4px;">
                <div class="flex-row">
                    <div><i class="fas fa-calendar-check" style="color:#ff7b2c;"></i> <strong>每日签到</strong></div>
                    <button class="btn-like" style="background: #ff9f4a; padding: 6px 18px;" onclick="alert('签到成功! +5积分')">立即签到 <i class="fas fa-check-circle"></i></button>
                </div>
                <div class="flex-row text-small" style="margin-top: 12px; gap: 12px; flex-wrap: wrap;">
                    <span><i class="fas fa-coins"></i> 赚取积分</span>
                    <span><i class="fas fa-tasks"></i> 完成任务赚积分</span>
                    <span><i class="fas fa-infinity"></i> 连续签到领积分</span>
                </div>
            </div>

            <!-- 随机点菜 -->
            <div class="random-dish flex-row" onclick="alert('随机推荐: 番茄牛腩煲 · 酸甜开胃')">
                <div>
                    <i class="fas fa-dice-d6" style="font-size: 28px; color:#ff7b2c;"></i>
                    <strong style="margin-left: 8px;">随机点菜</strong>
                    <div class="text-small" style="margin-top: 4px;">不知道吃什么？帮你选！</div>
                </div>
                <i class="fas fa-shuffle" style="font-size: 24px; color:#ffad70;"></i>
            </div>
        </div>

        <!-- 我的页面 (页面4) -->
        <div id="profilePage" class="page">
            <!-- 用户头部 -->
            <div class="flex-row" style="margin-bottom: 16px;">
                <div class="flex-row" style="gap: 12px;">
                    <div class="avatar">
                        <i class="fas fa-user-chef"></i>
                    </div>
                    <div>
                        <div style="font-weight: 800; font-size: 18px;">用户S7Vo8EWE</div>
                        <div class="text-small" style="color:#8e8e93;">用户ID: 49642</div>
                    </div>
                </div>
                <i class="fas fa-qrcode" style="font-size: 24px; color:#cbcbcb;"></i>
            </div>
            <!-- 统计数据 菜谱/采摘/关注/粉丝 -->
            <div class="stat-row">
                <div class="stat-item"><div class="stat-num">0</div><div class="text-small">菜谱</div></div>
                <div class="stat-item"><div class="stat-num">0</div><div class="text-small">采摘</div></div>
                <div class="stat-item"><div class="stat-num">0</div><div class="text-small">关注</div></div>
                <div class="stat-item"><div class="stat-num">0</div><div class="text-small">粉丝</div></div>
            </div>
            <!-- 功能列表 -->
            <div class="card" style="padding: 4px 0;">
                <div class="list-menu-item" onclick="alert('最新活动: 春日美食节正在进行中')">
                    <span><i class="fas fa-bullhorn inline-icon"></i> 公告中心</span>
                    <span class="text-small">最新活动资讯 <i class="fas fa-chevron-right"></i></span>
                </div>
                <div class="list-menu-item" onclick="alert('完成每日任务领积分')">
                    <span><i class="fas fa-check-circle inline-icon"></i> 任务中心</span>
                    <span class="text-small">每日任务领积分 <i class="fas fa-chevron-right"></i></span>
                </div>
                <div class="list-menu-item" onclick="alert('邀请好友一起赚积分')">
                    <span><i class="fas fa-share-square inline-icon"></i> 分享推荐</span>
                    <span class="text-small">邀请好友赚积分 <i class="fas fa-chevron-right"></i></span>
                </div>
                <div class="list-menu-item" onclick="alert('绑定微信, 快速登录')">
                    <span><i class="fab fa-weixin inline-icon"></i> 加入微信</span>
                    <span class="text-small">加入微信帐号 <i class="fas fa-chevron-right"></i></span>
                </div>
                <div class="list-menu-item" onclick="alert('绑定情侣,共享厨房')">
                    <span><i class="fas fa-heart inline-icon"></i> 情侣绑定</span>
                    <i class="fas fa-chevron-right"></i>
                </div>
                <div class="list-menu-item" onclick="alert('开通会员尊享免广告+专属菜谱')">
                    <span><i class="fas fa-crown inline-icon"></i> 开通会员</span>
                    <i class="fas fa-chevron-right"></i>
                </div>
                <div class="list-menu-item" onclick="alert('积分充值: 100积分 = 10元')">
                    <span><i class="fas fa-coins inline-icon"></i> 积分充值</span>
                    <span class="text-small">100积分 <i class="fas fa-chevron-right"></i></span>
                </div>
                <div class="list-menu-item" onclick="alert('客服小助手在线时间 9-21点')">
                    <span><i class="fas fa-headset inline-icon"></i> 联系客服</span>
                    <i class="fas fa-chevron-right"></i>
                </div>
                <div class="list-menu-item" onclick="alert('使用帮助文档')">
                    <span><i class="fas fa-question-circle inline-icon"></i> 使用帮助</span>
                    <i class="fas fa-chevron-right"></i>
                </div>
                <div class="list-menu-item" onclick="if(confirm('确定退出登录吗?')){ alert('已退出'); }">
                    <span style="color:#ff5a5a;"><i class="fas fa-sign-out-alt"></i> 退出登录</span>
                </div>
            </div>
            <div class="text-small" style="text-align:center; margin: 24px 0 12px; color:#bbb;">© 厨房日记 · 美味相伴</div>
        </div>
    </div>

    <!-- 底部导航栏 -->
    <div class="bottom-nav">
        <div class="nav-item" data-tab="kitchen">
            <i class="fas fa-kitchen-set"></i><span>厨房</span>
        </div>
        <div class="nav-item" data-tab="order">
            <i class="fas fa-clipboard-list"></i><span>订单</span>
        </div>
        <div class="nav-item" data-tab="discover">
            <i class="fas fa-compass"></i><span>发现</span>
        </div>
        <div class="nav-item" data-tab="profile">
            <i class="fas fa-user"></i><span>我的</span>
        </div>
    </div>
</div>

<script>
    // 页面切换函数
    function switchTab(tabId) {
        // 隐藏所有页面
        document.querySelectorAll('.page').forEach(page => {
            page.classList.remove('active-page');
        });
        const activePage = document.getElementById(tabId + 'Page');
        if (activePage) activePage.classList.add('active-page');
        
        // 底部导航样式切换
        document.querySelectorAll('.nav-item').forEach(item => {
            item.classList.remove('active');
            if (item.getAttribute('data-tab') === tabId) {
                item.classList.add('active');
            }
        });
        
        // 特殊场景：如果切换到厨房页面，刷新空菜品状态展示（保留静态）
        // 小细节: 没有任何额外数据但保证完整性
    }
    
    // 绑定底部导航事件
    document.querySelectorAll('.nav-item').forEach(nav => {
        nav.addEventListener('click', (e) => {
            const tab = nav.getAttribute('data-tab');
            switchTab(tab);
        });
    });
    
    // 分类标签切换 (全部/热菜/凉菜) 模拟暂无菜品内容不变
    window.switchFoodTag = function(element, tagName) {
        // 移除其他active-tag类
        const container = element.parentElement;
        const allTags = container.querySelectorAll('.tag');
        allTags.forEach(tag => tag.classList.remove('active-tag'));
        element.classList.add('active-tag');
        const emptyDiv = document.getElementById('emptyDishArea');
        if (emptyDiv) {
            // 动态改变显示文字，依然暂无菜品
            let msg = '';
            if (tagName === '热菜') msg = '暂无热菜，快去管理菜单添加吧';
            else if (tagName === '凉菜') msg = '暂无凉菜，添加些清爽小菜吧';
            else msg = '暂无菜品，点击「管理菜单」按钮开始添加你的美食';
            emptyDiv.querySelector('p:first-of-type').innerText = msg || '暂无菜品';
            if(tagName !== '全部') {
                emptyDiv.querySelector('.text-small').innerText = `当前分类“${tagName}”空空如也，快去添加～`;
            } else {
                emptyDiv.querySelector('.text-small').innerText = '点击「管理菜单」按钮开始添加你的美食';
            }
        }
    }
    
    // 去点餐按钮额外绑定确保切换厨房
    document.getElementById('goToKitchenBtn')?.addEventListener('click', function(e) {
        e.stopPropagation();
        switchTab('kitchen');
    });
    
    // 如果有从其他地方调用，确保订单页的去点餐也能正确切换
    // 另外处理订单通知服务，积分明细等点击alert已在html内联定义，完美
    
    // 默认激活厨房页面标识 (加载完成时确认高亮)
    window.addEventListener('DOMContentLoaded', () => {
        // 保证底部高亮是厨房
        const activeNow = document.querySelector('.page.active-page')?.id;
        if (activeNow === 'kitchenPage') {
            document.querySelector('.nav-item[data-tab="kitchen"]').classList.add('active');
        } else {
            switchTab('kitchen');
        }
        // 手动设置默认标签为“全部”高亮
        const firstTag = document.querySelector('.tag-group .tag');
        if (firstTag && !firstTag.classList.contains('active-tag')) {
            firstTag.classList.add('active-tag');
        }
        // 同步厨房页的空菜品文案
        const emptyDiv = document.getElementById('emptyDishArea');
        if(emptyDiv) {
            const pMain = emptyDiv.querySelector('p:first-of-type');
            if(pMain && pMain.innerText !== '暂无菜品') pMain.innerText = '暂无菜品';
        }
    });
    
    // 随机点菜再次点击额外提醒，防止冲突
    // 所有模仿完整厨房、订单、发现、我的样式均按照截图重建
    // 额外添加: 积分明细在订单页已含, 订单通知服务(+1)已包含
    // 确保页面完全符合四个截图的所有文字模块～
    // 厨房页最顶上 75 积分展示完全；订单页显示记录0个订单；
    // 发现页所有板块：菜谱广场/家常录/家乡美食/我的美食记录/分享家乡味道/每日签到/随机点菜全部复制
    // 我的页显示用户id, 0数据, 公告中心到退出登录完整列表, 加入微信、情侣绑定、积分充值100积分等都存在 ✅
    // 底部导航完全复制原图（厨房 订单 发现 我的）
</script>
</body>
</html>
