/** 婚姻
 */
declare interface ProtoFmtInfo {
    17200: {
        desc: "打开征友大厅界面";
        send: (
            number: 17200,
            fmt: "c",
            args: [
                /**1大厅 2我的关注 3我的粉丝*/
                page: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**1大厅 2我的关注 3我的粉丝*/
            page: number
        ];
        recv: {
            /** 错误码 */
            code: number;
            /** 1大厅 2我的关注 3我的粉丝 */
            page: number;
            /** 人气 */
            own_popularity: number;
            /** 关注发送时间 */
            ask_follow_time: number;
            /** 送花发送时间 */
            ask_flower_time: number;
            /** 剩余免费发送普通征友信息次数 */
            less_free_times: number;
            player_list: {
                /** 玩家id */
                role_id: number;
                /**  玩家名字 */
                name: string;
                /** 等级 */
                lv: number;
                /** 性别 */
                sex: number;
                /** vip */
                vip: number;
                /** 职业 */
                career: number;
                /** 转职次数 */
                turn: number;
                /** 0单身 1情侣 2已婚 */
                if_marriage: number;
                /**  头像地址 */
                picture: string;
                /** 头像版本号 */
                picture_ver: number;
                /** 0不在线 1在线 */
                if_online: number;
                /** 人气 */
                popularity: number;
                /**  交友宣言 */
                msg: string;
                /** 0普通 1置顶 */
                type: number;
                /** 发布时间 */
                time: number;
                /** 是否关注 */
                if_follow: number;
                /** 是否好友 */
                if_friend: number;
                /** 亲密度 */
                intimacy: number;
                tag_list: {
                    tag_id: number;
                    tag_subid: number;
                }[];
                /** VIP经验 */
                vip_exp: number;
            }[];
        };
    };
    17201: {
        desc: "关注/取消关注玩家";
        send: (
            number: 17201,
            fmt: "lc",
            args: [
                /**玩家id*/
                follow_role_id: number,
                /**1关注 2取消关注*/
                type: number
            ]
        ) => never;
        sendFmt: "lc";
        sendArgs: [
            /**玩家id*/
            follow_role_id: number,
            /**1关注 2取消关注*/
            type: number
        ];
        recv: {
            /** 错误码 */
            code: number;
            /** 玩家id */
            follow_role_id: number;
            /** 1关注 2取消关注 */
            type: number;
        };
    };
    17202: {
        desc: "发布信息";
        send: (
            number: 17202,
            fmt: "scA",
            args: [
                /** 信息*/
                msg: string,
                /**0普通 1特别*/
                type: number,
                tag_list: any
            ]
        ) => never;
        sendFmt: "scA";
        sendArgs: [
            /** 信息*/
            msg: string,
            /**0普通 1特别*/
            type: number,
            tag_list: any
        ];
        recv: {
            /** 错误码 */
            code: number;
            /** 0普通 1特别 */
            type: number;
        };
    };
    17203: {
        desc: "求送花/求关注(暂时没用)协议不用";
        send: (
            number: 17203,
            fmt: "cs",
            args: [
                /**1送花 2关注*/
                type: number,
                /** 信息*/
                msg: string
            ]
        ) => never;
        sendFmt: "cs";
        sendArgs: [
            /**1送花 2关注*/
            type: number,
            /** 信息*/
            msg: string
        ];
        recv: {
            /** 错误码 */
            code: number;
            /** 1送花 2关注 */
            type: number;
            /** 发送时间 */
            time: number;
        };
    };
    17204: {
        desc: "修改交友信息";
        send: (
            number: 17204,
            fmt: "sA",
            args: [
                /** 信息 ，如果不修改这个字段，发空字符串*/
                msg: string,
                /**标签，不修改这个字段，发[]*/
                tag_list: any
            ]
        ) => never;
        sendFmt: "sA";
        sendArgs: [
            /** 信息 ，如果不修改这个字段，发空字符串*/
            msg: string,
            /**标签，不修改这个字段，发[]*/
            tag_list: any
        ];
        recv: {
            /** 错误码 */
            code: number;
            /**  最新的信息 */
            msg: string;
            /** 最新的标签 */
            tag_list: {
                tag_id: number;
                tag_subid: number;
            }[];
        };
    };
    17205: {
        desc: "获取玩家细节信息";
        send: (number: 17205, fmt: "l", args: [role_id: number]) => never;
        sendFmt: "l";
        sendArgs: [role_id: number];
        recv: {
            role_id: number;
            guild_id: number;
            guild_name: string;
        };
    };
    17210: {
        desc: "打开戒指界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 */
            code: number;
            /** 阶数 */
            stage: number;
            /** 星数 */
            star: number;
            /** 祝福值 */
            pray_num: number;
            /** 戒指战力 */
            ring_combat_power: number;
            /** 打磨列表(为空，不用) */
            polish_list: {
                /** 物品类型id */
                goods_type_id: number;
                /** 物品使用次数 */
                use_num: number;
            }[];
            /** 属性列表(为空，不用) */
            attr_list: {
                /** 属性类型 */
                attr_type: number;
                /** 属性数目 */
                attr_num: number;
            }[];
        };
    };
    17211: {
        desc: "解锁戒指";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 */
            code: number;
            /** 阶数 */
            stage: number;
            /** 星数 */
            star: number;
            /** 祝福值 */
            pray_num: number;
        };
    };
    17212: {
        desc: "戒指提升";
        send: (
            number: 17212,
            fmt: "i",
            args: [
                /**物品类型id*/
                goods_type_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**物品类型id*/
            goods_type_id: number
        ];
        recv: {
            /** 返回码 */
            code: number;
            /** 物品类型id */
            goods_type_id: number;
            /** 阶数 */
            stage: number;
            /** 星数 */
            star: number;
            /** 祝福值 */
            pray_num: number;
        };
    };
    17213: {
        desc: "戒指一键提升";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 */
            code: number;
            /** 阶数 */
            stage: number;
            /** 星数 */
            star: number;
            /** 祝福值 */
            pray_num: number;
        };
    };
    17220: {
        desc: "打开表白界面(不用)协议不用";
        send: (
            number: 17220,
            fmt: "l",
            args: [
                /**玩家id*/
                role_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**玩家id*/
            role_id: number
        ];
        recv: {
            /** 返回码 */
            code: number;
            /** 玩家id */
            role_id: number;
            /**  名字 */
            name: string;
            /** 等级 */
            lv: number;
            /** 战力 */
            combat_power: number;
            /** 性别 */
            sex: number;
            /** vip */
            vip: number;
            /** 职业 */
            career: number;
            /** 转职次数 */
            turn: number;
        };
    };
    17221: {
        desc: "发送表白(不用)协议不用";
        send: (
            number: 17221,
            fmt: "ls",
            args: [
                /**玩家id*/
                role_id: number,
                /** 表白信息*/
                msg: string
            ]
        ) => never;
        sendFmt: "ls";
        sendArgs: [
            /**玩家id*/
            role_id: number,
            /** 表白信息*/
            msg: string
        ];
        recv: {
            /** 返回码 */
            code: number;
        };
    };
    17222: {
        desc: "收到表白/求婚/aa制再次举行婚礼/协商离婚";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家id */
            role_id: number;
            /**  名字 */
            name: string;
            /** 等级 */
            lv: number;
            /** 战力 */
            combat_power: number;
            /** 性别 */
            sex: number;
            /** vip */
            vip: number;
            /** 职业 */
            career: number;
            /** 转职次数 */
            turn: number;
            picture: string;
            picture_ver: number;
            /** 1表白 2求婚 3aa制婚礼 4 协商离婚 5 请求购买礼包 */
            type: number;
            /** 0没有（表白用） 1下 2中 3高 */
            propose_type: number;
            /**  表白信息 */
            msg: string;
            /** 是否aa 1是 0否 (求婚没有aa，可以不管这个字段) */
            if_aa: number;
            cost_list: {
                goods_type: number;
                goods_type_id: number;
                goods_num: number;
            }[];
        };
    };
    17223: {
        desc: "回应表白/求婚";
        send: (
            number: 17223,
            fmt: "lc",
            args: [
                /**玩家id*/
                role_id: number,
                /**1答应 2拒绝*/
                type: number
            ]
        ) => never;
        sendFmt: "lc";
        sendArgs: [
            /**玩家id*/
            role_id: number,
            /**1答应 2拒绝*/
            type: number
        ];
        recv: {
            /** 返回码 */
            code: number;
            /** 玩家id */
            role_id: number;
            /** 1答应 2拒绝 */
            type: number;
        };
    };
    17224: {
        desc: "收到回应表白/求婚/离婚结果";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家id */
            role_id: number;
            /** 1表白 2求婚 3离婚 4分手 5AA制再次 */
            type: number;
            /** 0无 1答应 2拒绝 */
            answer_type: number;
        };
    };
    17225: {
        desc: "确认表白/求婚/离婚结果协议不用";
        send: (
            number: 17225,
            fmt: "l",
            args: [
                /**对方玩家id*/
                role_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**对方玩家id*/
            role_id: number
        ];
        recv: {
            /** 返回码 */
            code: number;
        };
    };
    17226: {
        desc: "表白/求婚/离婚信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 需回应的信息 */
            biaobai_list: {
                /** 玩家id */
                role_id: number;
                /**  名字 */
                name: string;
                /** 等级 */
                lv: number;
                /** 战力 */
                combat_power: number;
                /** 性别 */
                sex: number;
                /** vip */
                vip: number;
                /** 职业 */
                career: number;
                /** 转职次数 */
                turn: number;
                /** 1表白 2求婚 3aa制婚礼 */
                type: number;
                /** 0没有（表白用） 1下 2中 3高 */
                propose_type: number;
                /**  表白信息 */
                msg: string;
                /** 是否aa 1是 0否 */
                if_aa: number;
                cost_list: {
                    goods_type: number;
                    goods_type_id: number;
                    goods_num: number;
                }[];
            }[];
            /** 对方的回应信息 */
            biaobai_answer_list: {
                /** 玩家id */
                role_id: number;
                /**  名字 */
                name: string;
                /** 等级 */
                lv: number;
                /** 战力 */
                combat_power: number;
                /** 性别 */
                sex: number;
                /** vip */
                vip: number;
                /** 职业 */
                career: number;
                /** 转职次数 */
                turn: number;
                /** 1表白 2求婚 3离婚 */
                type: number;
                /** 1答应 2拒绝 */
                answer_type: number;
            }[];
        };
    };
    17229: {
        desc: "其他信息推送(一些信息变更推送)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            list: {
                /** 1 恩爱值 */
                key: number;
                val: number;
            }[];
        };
    };
    17230: {
        desc: "打开求婚界面协议不用";
        send: (
            number: 17230,
            fmt: "l",
            args: [
                /**玩家id*/
                role_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**玩家id*/
            role_id: number
        ];
        recv: {
            /** 返回码 */
            code: number;
            /** 玩家id */
            role_id: number;
            /**  名字 */
            name: string;
            /** 等级 */
            lv: number;
            /** 战力 */
            combat_power: number;
            /** 性别 */
            sex: number;
            /** vip */
            vip: number;
            /** 职业 */
            career: number;
            /** 转职次数 */
            turn: number;
        };
    };
    17231: {
        desc: "发送求婚";
        send: (
            number: 17231,
            fmt: "lcsc",
            args: [
                /**玩家id*/
                role_id: number,
                /**婚礼类型 1下 2中 3上*/
                wedding_type: number,
                /** 表白信息*/
                msg: string,
                /**是否aa：1是 0否 （没有aa）*/
                if_aa: number
            ]
        ) => never;
        sendFmt: "lcsc";
        sendArgs: [
            /**玩家id*/
            role_id: number,
            /**婚礼类型 1下 2中 3上*/
            wedding_type: number,
            /** 表白信息*/
            msg: string,
            /**是否aa：1是 0否 （没有aa）*/
            if_aa: number
        ];
        recv: {
            /** 返回码 */
            code: number;
            /** 玩家id */
            role_id: number;
        };
    };
    17232: {
        desc: "打开我的伴侣";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 */
            code: number;
            /** 玩家id */
            role_id: number;
            /** 战力 */
            combat_power: number;
            /** 玩家名字 */
            name: string;
            /** 性别 */
            sex: number;
            /** 阵营 */
            realm: number;
            /** 职业 */
            career: number;
            /** 等级 */
            level: number;
            /** 是否GM */
            GM: number;
            /** VIP */
            vip_flag: number;
            /** 职称 */
            touxian: number;
            /** 等级模型 */
            level_model_list: {
                /** 部位 */
                part_pos: number;
                /** 模型id */
                level_model_id: number;
            }[];
            /** 时装模型 */
            fashion_model_list: {
                /** 部位 */
                part_pos: number;
                /** 模型id */
                fashion_model_id: number;
                figure_chartlet_id: number;
            }[];
            /** 自定义头像url */
            picture: string;
            /** 自定义头像版本号 */
            prcture_ver: number;
            /** 帮派id */
            guild_id: number;
            /** 帮派名字 */
            guild_name: string;
            /** 帮派职位 */
            position: number;
            /** 帮派职位名字 */
            position_name: string;
            /** 称号 */
            dsgt_id: number;
            /** 活跃度形象Id */
            image_id: number;
            /** 转生次数 */
            turn: number;
            /** 转生阶段 */
            turn_stage: number;
            /** 爵位等级 */
            grade_id: number;
            /** 结婚状态 0单身 1情侣 2结婚 */
            is_marriage: number;
            /** 伴侣玩家id */
            marriage_id: number;
            /** 伴侣玩家name */
            marriage_name: string;
            /** 护送天使id */
            escort_state: number;
            /** 房子街区id */
            block_id: number;
            /** 房子id */
            house_id: number;
            /** 房子等级 */
            house_lv: number;
            /** 幻化模型 */
            figure_list: {
                /** 类型 （1:坐骑 2：伙伴 3: 翅膀 4:神器 5：圣器 6：精灵 7：宠物） */
                figure_type: number;
                /** 模型id */
                figure_id: number;
                figure_chartlet_id: number;
            }[];
            /** 幻化模型是否骑乘##找不到数据就默认骑乘 */
            figure_ride_list: {
                /** 类型 （1:坐骑 2：伙伴 3: 翅膀 4:神器 5：圣器 6：精灵 7：宠物） */
                figure_type: number;
                /** 是否骑乘(用于场景表现,点击头像等等忽略本字段) */
                is_ride: number;
            }[];
            /** 成就等级 */
            achv_lv: number;
            /** 勋章id */
            medal_id: number;
            /** 法阵id */
            fazhen_id: number;
            /** 装扮列表 */
            dress_list: {
                /** 装扮类型 */
                dress_type: number;
                /** 装扮id */
                dress_id: number;
            }[];
            /** 将神id */
            god_id: number;
            /** 天启套装 */
            revelation_suit: number;
            /** 使魔id */
            demon_id: number;
            /** 是否有至尊vip标识 */
            supreme_vip: number;
            /** 头衔id */
            title_id: number;
            /** 蒙面id */
            mask_id: number;
            /** 阵营四海争霸(玩家阵营) */
            seaCamp: number;
            /** 海战日常砖块品质 */
            brick_id: number;
            /** 假人类型（0:玩家） */
            dummy_type: number;
            /** 套装贴图id */
            suit_fashion_id: number;
            /** 采集状态 （0：非采集， 1：采集中） */
            collect_state: number;
            /** 1情侣 2夫妻 */
            type: number;
            /** 类型 0结婚预约 1当前无婚礼预约 2再次预约 3已预约 4不是求婚花费结婚卡玩家在0阶段 5 不是求婚花费结婚卡玩家在2，3阶段 */
            now_wedding_state: number;
            /** 结婚时间戳 */
            anniversary_time: number;
            /** 恩爱值 */
            love_num: number;
            /** 0:没结过婚 1结过婚 */
            first_marriage: number;
        };
    };
    17233: {
        desc: "打开分手/离婚协议不用";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 */
            code: number;
            /** 1情侣 2夫妻 */
            type: number;
            /** 货币类型 */
            cost_type: number;
            /** 消耗数量 */
            cost_num: number;
        };
    };
    17234: {
        desc: "发送分手/离婚";
        send: (
            number: 17234,
            fmt: "c",
            args: [
                /**1 协商离婚 2 强制离婚*/
                divorce_type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**1 协商离婚 2 强制离婚*/
            divorce_type: number
        ];
        recv: {
            /** 返回码 */
            code: number;
        };
    };
    17235: {
        desc: "回应分手/离婚";
        send: (
            number: 17235,
            fmt: "c",
            args: [
                /**1 同意 2 拒绝*/
                answer_type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**1 同意 2 拒绝*/
            answer_type: number
        ];
        recv: {
            /** 返回码 */
            code: number;
            /** 1 同意 2 拒绝 */
            answer_type: number;
        };
    };
    17236: {
        desc: "领取恩爱称号奖励";
        send: (
            number: 17236,
            fmt: "c",
            args: [
                /**id*/
                id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**id*/
            id: number
        ];
        recv: {
            /** 返回码 */
            code: number;
            id: number;
        };
    };
    17237: {
        desc: "购买真爱礼包";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 */
            code: number;
        };
    };
    17238: {
        desc: "真爱礼包信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 自己购买的真爱礼包过期时间戳 0:没有 */
            love_gift_time_s: number;
            /** 对方购买的真爱礼包过期时间戳 */
            love_gift_time_o: number;
            gift_state: {
                /** 1:购买返还的奖励 2:登陆领取的奖励 */
                count_type: number;
                /** 状态 0:未领取 1: 已领取 */
                state: number;
                /** 领取时间 */
                time: number;
            }[];
        };
    };
    17239: {
        desc: "领取真爱礼包奖励";
        send: (
            number: 17239,
            fmt: "c",
            args: [
                /**1:购买返还的奖励 2:登陆领取的奖励*/
                count_type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**1:购买返还的奖励 2:登陆领取的奖励*/
            count_type: number
        ];
        recv: {
            code: number;
            /** 1:购买返还的奖励 2:登陆领取的奖励 */
            count_type: number;
            reward: any;
        };
    };
    17240: {
        desc: "请求对方购买礼包";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            code: number;
        };
    };
    17241: {
        desc: "培养一生一世";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 */
            code: number;
            /** 阶数 */
            stage: number;
            /** 心数 */
            heart: number;
            /** 恩爱值 */
            love_num: number;
            /** 战力 */
            combat_power: number;
        };
    };
    17242: {
        desc: "秀恩爱";
        send: (
            number: 17242,
            fmt: "c",
            args: [
                /**序号*/
                type_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**序号*/
            type_id: number
        ];
        recv: {
            /** 返回码 */
            code: number;
        };
    };
    17243: {
        desc: "领取狗粮";
        send: (
            number: 17243,
            fmt: "lli",
            args: [
                /**男方玩家id*/
                role_id_m: number,
                /**女方玩家id*/
                role_id_w: number,
                /**狗粮id*/
                dog_food_id: number
            ]
        ) => never;
        sendFmt: "lli";
        sendArgs: [
            /**男方玩家id*/
            role_id_m: number,
            /**女方玩家id*/
            role_id_w: number,
            /**狗粮id*/
            dog_food_id: number
        ];
        recv: {
            /** 返回码 */
            code: number;
            /** 男方玩家id */
            role_id_m: number;
            /** 女方玩家id */
            role_id_w: number;
            /** 狗粮id */
            dog_food_id: number;
            /** 奖励数量 */
            goods_num: number;
        };
    };
    17244: {
        desc: "通知狗粮到了/没了";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1狗粮到了 2狗粮没了 */
            type: number;
            /** 男方玩家id */
            role_id_m: number;
            /** 女方玩家id */
            role_id_w: number;
            /** 狗粮id */
            dog_food_id: number;
            /**  男方名字 */
            name_m: string;
            /**  女方名字 */
            name_w: string;
            /** 时间 */
            time: number;
        };
    };
    17245: {
        desc: "进入/退出匹配";
        send: (
            number: 17245,
            fmt: "ci",
            args: [
                /**0 查看匹配状态 1 进入匹配 2 退出匹配*/
                type: number,
                dun_id: number
            ]
        ) => never;
        sendFmt: "ci";
        sendArgs: [
            /**0 查看匹配状态 1 进入匹配 2 退出匹配*/
            type: number,
            dun_id: number
        ];
        recv: {
            code: number;
            type: number;
            dun_id: number;
        };
    };
    17246: {
        desc: "匹配结果";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0 失败 1 成功 2 对方拒绝 3 己方拒绝 */
            code: number;
            list: {
                /** 1 男方 2 女方 */
                type: number;
                role_id: number;
                /** 玩家名字 */
                name: string;
                /** 性别 */
                sex: number;
                /** 阵营 */
                realm: number;
                /** 职业 */
                career: number;
                /** 等级 */
                level: number;
                /** 是否GM */
                GM: number;
                /** VIP */
                vip_flag: number;
                /** 职称 */
                touxian: number;
                /** 等级模型 */
                level_model_list: {
                    /** 部位 */
                    part_pos: number;
                    /** 模型id */
                    level_model_id: number;
                }[];
                /** 时装模型 */
                fashion_model_list: {
                    /** 部位 */
                    part_pos: number;
                    /** 模型id */
                    fashion_model_id: number;
                    figure_chartlet_id: number;
                }[];
                /** 自定义头像url */
                picture: string;
                /** 自定义头像版本号 */
                prcture_ver: number;
                /** 帮派id */
                guild_id: number;
                /** 帮派名字 */
                guild_name: string;
                /** 帮派职位 */
                position: number;
                /** 帮派职位名字 */
                position_name: string;
                /** 称号 */
                dsgt_id: number;
                /** 活跃度形象Id */
                image_id: number;
                /** 转生次数 */
                turn: number;
                /** 转生阶段 */
                turn_stage: number;
                /** 爵位等级 */
                grade_id: number;
                /** 结婚状态 0单身 1情侣 2结婚 */
                is_marriage: number;
                /** 伴侣玩家id */
                marriage_id: number;
                /** 伴侣玩家name */
                marriage_name: string;
                /** 护送天使id */
                escort_state: number;
                /** 房子街区id */
                block_id: number;
                /** 房子id */
                house_id: number;
                /** 房子等级 */
                house_lv: number;
                /** 幻化模型 */
                figure_list: {
                    /** 类型 （1:坐骑 2：伙伴 3: 翅膀 4:神器 5：圣器 6：精灵 7：宠物） */
                    figure_type: number;
                    /** 模型id */
                    figure_id: number;
                    figure_chartlet_id: number;
                }[];
                /** 幻化模型是否骑乘##找不到数据就默认骑乘 */
                figure_ride_list: {
                    /** 类型 （1:坐骑 2：伙伴 3: 翅膀 4:神器 5：圣器 6：精灵 7：宠物） */
                    figure_type: number;
                    /** 是否骑乘(用于场景表现,点击头像等等忽略本字段) */
                    is_ride: number;
                }[];
                /** 成就等级 */
                achv_lv: number;
                /** 勋章id */
                medal_id: number;
                /** 法阵id */
                fazhen_id: number;
                /** 装扮列表 */
                dress_list: {
                    /** 装扮类型 */
                    dress_type: number;
                    /** 装扮id */
                    dress_id: number;
                }[];
                /** 将神id */
                god_id: number;
                /** 天启套装 */
                revelation_suit: number;
                /** 使魔id */
                demon_id: number;
                /** 是否有至尊vip标识 */
                supreme_vip: number;
                /** 头衔id */
                title_id: number;
                /** 蒙面id */
                mask_id: number;
                /** 阵营四海争霸(玩家阵营) */
                seaCamp: number;
                /** 海战日常砖块品质 */
                brick_id: number;
                /** 假人类型（0:玩家） */
                dummy_type: number;
                /** 套装贴图id */
                suit_fashion_id: number;
                /** 采集状态 （0：非采集， 1：采集中） */
                collect_state: number;
                power: number;
            }[];
            /** 3秒后进入 */
            enter_time: number;
        };
    };
    17249: {
        desc: "打开婚礼预约状态";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 类型 0未预约  2已预约 */
            now_wedding_state: number;
            begin_time: number;
        };
    };
    17250: {
        desc: "打开婚礼预约界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
            /** 类型 0未预约  2已预约 */
            now_wedding_state: number;
            my_wedding_times: {
                /** 婚礼类型 1普通 2 高档 */
                wedding_type: number;
                /** 已使用次数 */
                use_times: number;
                /** 总次数 */
                max_times: number;
                /** 今天是否已预约:只对简约婚宴有用 */
                order_today: number;
            }[];
            day_list: {
                /** 预约当天0点时间戳 */
                order_unix_date: number;
                time_list: {
                    /** 时间段序号 */
                    time_id: number;
                    order_list: {
                        /** 男方玩家id */
                        role_id_m: number;
                        /** 女方玩家id */
                        role_id_w: number;
                        /** 婚礼类型 1普通 2 高档 */
                        wedding_type: number;
                        /** 是否为自己的预约 */
                        if_own: number;
                    }[];
                }[];
            }[];
        };
    };
    17251: {
        desc: "预约婚礼";
        send: (
            number: 17251,
            fmt: "ccc",
            args: [
                /**1今天 2明天 3后天 4大后天 。。。*/
                day_id: number,
                /**时间段序号*/
                time_id: number,
                /**婚宴类型*/
                wedding_type: number
            ]
        ) => never;
        sendFmt: "ccc";
        sendArgs: [
            /**1今天 2明天 3后天 4大后天 。。。*/
            day_id: number,
            /**时间段序号*/
            time_id: number,
            /**婚宴类型*/
            wedding_type: number
        ];
        recv: {
            /** 错误码 */
            code: number;
            /** 婚礼时间 */
            time: number;
            /** 婚礼类型 */
            wedding_type: number;
            man_list: {
                /** 玩家id */
                role_id_m: number;
                /**  名字 */
                name: string;
                /** 等级 */
                lv: number;
                /** 战力 */
                combat_power: number;
                /** 性别 */
                sex: number;
                /** vip */
                vip: number;
                /** 职业 */
                career: number;
                /** 转职次数 */
                turn: number;
            }[];
            woman_list: {
                /** 玩家id */
                role_id_w: number;
                /**  名字 */
                name: string;
                /** 等级 */
                lv: number;
                /** 战力 */
                combat_power: number;
                /** 性别 */
                sex: number;
                /** vip */
                vip: number;
                /** 职业 */
                career: number;
                /** 转职次数 */
                turn: number;
            }[];
        };
    };
    17252: {
        desc: "打开邀请宾客";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
            /** 自己的id */
            my_role_id: number;
            /**  自己的名字 */
            my_name: string;
            /**  头像 */
            my_picture: string;
            my_picture_ver: number;
            /** 伴侣玩家id */
            lover_role_id: number;
            /**  名字 */
            lover_name: string;
            /**  头像 */
            lover_picture: string;
            lover_picture_ver: number;
            /** 婚礼类型 */
            wedding_type: number;
            /** 婚礼时间 */
            wedding_time: number;
            /** 0不可 1可以 */
            if_order_again: number;
            /** 邀请剩余数量 */
            less_invite_num: number;
            /** 宾客总数 */
            guest_num: number;
            guest_list: {
                /** 玩家id */
                role_id: number;
                /** 0未回答 1答应 2拒绝, 现在只有1 */
                answer_type: number;
                /**  宾客名字 */
                name: string;
            }[];
            ask_invite_list: {
                /** 玩家id */
                role_id: number;
                /**  名字 */
                name: string;
            }[];
        };
    };
    17253: {
        desc: "邀请宾客";
        send: (number: 17253, fmt: any, args: [invite_list: any]) => never;
        sendFmt: any;
        sendArgs: [invite_list: any];
        recv: {
            /** 错误码 */
            code: number;
            invite_list: {
                /** 玩家id */
                role_id: number;
            }[];
        };
    };
    17254: {
        desc: "获取邀请过自己的婚礼列表暂时先不用，看后面的需求";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            invite_list: {
                /** 婚礼类型 */
                wedding_type: number;
                /** 开始时间 */
                start_time: number;
                /** 是否接受邀请 0未接受 1接受 */
                if_answer: number;
                man_list: {
                    /** 玩家id */
                    role_id: number;
                    /**  名字 */
                    name: string;
                    /** 等级 */
                    lv: number;
                    /** 战力 */
                    combat_power: number;
                    /** 性别 */
                    sex: number;
                    /** vip */
                    vip: number;
                    /** 职业 */
                    career: number;
                    /** 转职次数 */
                    turn: number;
                }[];
                woman_list: {
                    /** 玩家id */
                    role_id: number;
                    /**  名字 */
                    name: string;
                    /** 等级 */
                    lv: number;
                    /** 战力 */
                    combat_power: number;
                    /** 性别 */
                    sex: number;
                    /** vip */
                    vip: number;
                    /** 职业 */
                    career: number;
                    /** 转职次数 */
                    turn: number;
                }[];
            }[];
        };
    };
    17255: {
        desc: "接受/拒绝邀请协议不用，因为邀请过就默认是对方是同意邀请的，对方不用回答";
        send: (
            number: 17255,
            fmt: "lc",
            args: [
                /**男方玩家id*/
                role_id_m: number,
                /**1接受 2拒绝*/
                answer_type: number
            ]
        ) => never;
        sendFmt: "lc";
        sendArgs: [
            /**男方玩家id*/
            role_id_m: number,
            /**1接受 2拒绝*/
            answer_type: number
        ];
        recv: {
            /** 错误码 */
            code: number;
            /** 男方玩家id */
            role_id_m: number;
            /** 1接受 2拒绝 */
            answer_type: number;
        };
    };
    17256: {
        desc: "通知婚礼开始/结束（只用于界面按钮的显示）";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1开始 0结束 */
            type: number;
            wedding_list: {
                /** 婚礼类型 */
                wedding_type: number;
                /** 开始时间 */
                start_time: number;
                man_list: {
                    /** 玩家id */
                    role_id: number;
                    /**  名字 */
                    name: string;
                    /** 等级 */
                    lv: number;
                    /** 战力 */
                    combat_power: number;
                    /** 性别 */
                    sex: number;
                    /** vip */
                    vip: number;
                    /** 职业 */
                    career: number;
                    /** 转职次数 */
                    turn: number;
                    picture: string;
                    picture_ver: number;
                }[];
                woman_list: {
                    /** 玩家id */
                    role_id: number;
                    /**  名字 */
                    name: string;
                    /** 等级 */
                    lv: number;
                    /** 战力 */
                    combat_power: number;
                    /** 性别 */
                    sex: number;
                    /** vip */
                    vip: number;
                    /** 职业 */
                    career: number;
                    /** 转职次数 */
                    turn: number;
                    picture: string;
                    picture_ver: number;
                }[];
                guest_list: {
                    /** 玩家id */
                    role_id: number;
                }[];
            }[];
        };
    };
    17257: {
        desc: "索要请柬";
        send: (
            number: 17257,
            fmt: "l",
            args: [
                /**男方玩家id*/
                role_id_m: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**男方玩家id*/
            role_id_m: number
        ];
        recv: {
            /** 错误码 */
            code: number;
        };
    };
    17258: {
        desc: "宾客购买请柬";
        send: (
            number: 17258,
            fmt: "l",
            args: [
                /**男方玩家id*/
                role_id_m: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**男方玩家id*/
            role_id_m: number
        ];
        recv: {
            /** 错误码 */
            code: number;
            /** 男方玩家id */
            role_id_m: number;
        };
    };
    17259: {
        desc: "购买上限";
        send: (
            number: 17259,
            fmt: "c",
            args: [
                /**购买数量*/
                num: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**购买数量*/
            num: number
        ];
        recv: {
            /** 错误码 */
            code: number;
            /** 邀请剩余数量 */
            less_invite_num: number;
            /** 宾客总数(购买后当前上限) */
            guest_num: number;
        };
    };
    17260: {
        desc: "索要请柬玩家列表更新";
        send: (number: 17260, fmt: any, args: [type_list: any]) => never;
        sendFmt: any;
        sendArgs: [type_list: any];
        recv: {
            /** 错误码 */
            code: number;
            /** 邀请剩余数量 */
            less_invite_num: number;
            list: {
                type: number;
                info_list: {
                    /** 玩家id */
                    role_id: number;
                    /** 这字段暂时不用，默认都是1 */
                    answer_type: number;
                    /**  宾客名字 */
                    name: string;
                }[];
            }[];
        };
    };
    17261: {
        desc: "答应/拒绝玩家索要请柬";
        send: (number: 17261, fmt: any, args: [guest_role_id: any]) => never;
        sendFmt: any;
        sendArgs: [guest_role_id: any];
        recv: {
            /** 错误码 */
            code: number;
        };
    };
    17262: {
        desc: "婚礼动画场景信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
            man_list: {
                /** 男方玩家id */
                role_id_m: number;
                /** 玩家名字 */
                name: string;
                /** 性别 */
                sex: number;
                /** 阵营 */
                realm: number;
                /** 职业 */
                career: number;
                /** 等级 */
                level: number;
                /** 是否GM */
                GM: number;
                /** VIP */
                vip_flag: number;
                /** 职称 */
                touxian: number;
                /** 等级模型 */
                level_model_list: {
                    /** 部位 */
                    part_pos: number;
                    /** 模型id */
                    level_model_id: number;
                }[];
                /** 时装模型 */
                fashion_model_list: {
                    /** 部位 */
                    part_pos: number;
                    /** 模型id */
                    fashion_model_id: number;
                    figure_chartlet_id: number;
                }[];
                /** 自定义头像url */
                picture: string;
                /** 自定义头像版本号 */
                prcture_ver: number;
                /** 帮派id */
                guild_id: number;
                /** 帮派名字 */
                guild_name: string;
                /** 帮派职位 */
                position: number;
                /** 帮派职位名字 */
                position_name: string;
                /** 称号 */
                dsgt_id: number;
                /** 活跃度形象Id */
                image_id: number;
                /** 转生次数 */
                turn: number;
                /** 转生阶段 */
                turn_stage: number;
                /** 爵位等级 */
                grade_id: number;
                /** 结婚状态 0单身 1情侣 2结婚 */
                is_marriage: number;
                /** 伴侣玩家id */
                marriage_id: number;
                /** 伴侣玩家name */
                marriage_name: string;
                /** 护送天使id */
                escort_state: number;
                /** 房子街区id */
                block_id: number;
                /** 房子id */
                house_id: number;
                /** 房子等级 */
                house_lv: number;
                /** 幻化模型 */
                figure_list: {
                    /** 类型 （1:坐骑 2：伙伴 3: 翅膀 4:神器 5：圣器 6：精灵 7：宠物） */
                    figure_type: number;
                    /** 模型id */
                    figure_id: number;
                    figure_chartlet_id: number;
                }[];
                /** 幻化模型是否骑乘##找不到数据就默认骑乘 */
                figure_ride_list: {
                    /** 类型 （1:坐骑 2：伙伴 3: 翅膀 4:神器 5：圣器 6：精灵 7：宠物） */
                    figure_type: number;
                    /** 是否骑乘(用于场景表现,点击头像等等忽略本字段) */
                    is_ride: number;
                }[];
                /** 成就等级 */
                achv_lv: number;
                /** 勋章id */
                medal_id: number;
                /** 法阵id */
                fazhen_id: number;
                /** 装扮列表 */
                dress_list: {
                    /** 装扮类型 */
                    dress_type: number;
                    /** 装扮id */
                    dress_id: number;
                }[];
                /** 将神id */
                god_id: number;
                /** 天启套装 */
                revelation_suit: number;
                /** 使魔id */
                demon_id: number;
                /** 是否有至尊vip标识 */
                supreme_vip: number;
                /** 头衔id */
                title_id: number;
                /** 蒙面id */
                mask_id: number;
                /** 阵营四海争霸(玩家阵营) */
                seaCamp: number;
                /** 海战日常砖块品质 */
                brick_id: number;
                /** 假人类型（0:玩家） */
                dummy_type: number;
                /** 套装贴图id */
                suit_fashion_id: number;
                /** 采集状态 （0：非采集， 1：采集中） */
                collect_state: number;
            }[];
            woman_list: {
                /** 女方玩家id */
                role_id_w: number;
                /** 玩家名字 */
                name: string;
                /** 性别 */
                sex: number;
                /** 阵营 */
                realm: number;
                /** 职业 */
                career: number;
                /** 等级 */
                level: number;
                /** 是否GM */
                GM: number;
                /** VIP */
                vip_flag: number;
                /** 职称 */
                touxian: number;
                /** 等级模型 */
                level_model_list: {
                    /** 部位 */
                    part_pos: number;
                    /** 模型id */
                    level_model_id: number;
                }[];
                /** 时装模型 */
                fashion_model_list: {
                    /** 部位 */
                    part_pos: number;
                    /** 模型id */
                    fashion_model_id: number;
                    figure_chartlet_id: number;
                }[];
                /** 自定义头像url */
                picture: string;
                /** 自定义头像版本号 */
                prcture_ver: number;
                /** 帮派id */
                guild_id: number;
                /** 帮派名字 */
                guild_name: string;
                /** 帮派职位 */
                position: number;
                /** 帮派职位名字 */
                position_name: string;
                /** 称号 */
                dsgt_id: number;
                /** 活跃度形象Id */
                image_id: number;
                /** 转生次数 */
                turn: number;
                /** 转生阶段 */
                turn_stage: number;
                /** 爵位等级 */
                grade_id: number;
                /** 结婚状态 0单身 1情侣 2结婚 */
                is_marriage: number;
                /** 伴侣玩家id */
                marriage_id: number;
                /** 伴侣玩家name */
                marriage_name: string;
                /** 护送天使id */
                escort_state: number;
                /** 房子街区id */
                block_id: number;
                /** 房子id */
                house_id: number;
                /** 房子等级 */
                house_lv: number;
                /** 幻化模型 */
                figure_list: {
                    /** 类型 （1:坐骑 2：伙伴 3: 翅膀 4:神器 5：圣器 6：精灵 7：宠物） */
                    figure_type: number;
                    /** 模型id */
                    figure_id: number;
                    figure_chartlet_id: number;
                }[];
                /** 幻化模型是否骑乘##找不到数据就默认骑乘 */
                figure_ride_list: {
                    /** 类型 （1:坐骑 2：伙伴 3: 翅膀 4:神器 5：圣器 6：精灵 7：宠物） */
                    figure_type: number;
                    /** 是否骑乘(用于场景表现,点击头像等等忽略本字段) */
                    is_ride: number;
                }[];
                /** 成就等级 */
                achv_lv: number;
                /** 勋章id */
                medal_id: number;
                /** 法阵id */
                fazhen_id: number;
                /** 装扮列表 */
                dress_list: {
                    /** 装扮类型 */
                    dress_type: number;
                    /** 装扮id */
                    dress_id: number;
                }[];
                /** 将神id */
                god_id: number;
                /** 天启套装 */
                revelation_suit: number;
                /** 使魔id */
                demon_id: number;
                /** 是否有至尊vip标识 */
                supreme_vip: number;
                /** 头衔id */
                title_id: number;
                /** 蒙面id */
                mask_id: number;
                /** 阵营四海争霸(玩家阵营) */
                seaCamp: number;
                /** 海战日常砖块品质 */
                brick_id: number;
                /** 假人类型（0:玩家） */
                dummy_type: number;
                /** 套装贴图id */
                suit_fashion_id: number;
                /** 采集状态 （0：非采集， 1：采集中） */
                collect_state: number;
            }[];
            guest_position_list: {
                /** 位置id */
                pos_id: number;
                /** 宾客玩家id */
                guest_role_id: number;
                /** 是否在场：0不在场 1在场 */
                if_enter: number;
            }[];
        };
    };
    17263: {
        desc: "进入婚礼场景";
        send: (
            number: 17263,
            fmt: "l",
            args: [
                /**男方玩家id*/
                role_id_m: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**男方玩家id*/
            role_id_m: number
        ];
        recv: {
            /** 错误码 */
            code: number;
        };
    };
    17264: {
        desc: "离开婚礼场景";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
        };
    };
    17265: {
        desc: "婚礼信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
            /** 婚礼阶段 */
            stage_id: number;
            /** 本阶段结束时间 */
            stage_end_time: number;
            /** 总气氛值 */
            aura: number;
            /** 获得普通喜糖数量 */
            less_normal_candies: number;
            /** 获得豪华喜糖数量 */
            less_special_candies: number;
            /** 宾客人数 */
            guests_num: number;
        };
    };
    17266: {
        desc: "撒喜糖";
        send: (
            number: 17266,
            fmt: "c",
            args: [
                /**1普通 2豪华*/
                candies_type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**1普通 2豪华*/
            candies_type: number
        ];
        recv: {
            /** 错误码 */
            code: number;
        };
    };
    17267: {
        desc: "放烟花";
        send: (
            number: 17267,
            fmt: "c",
            args: [
                /**1普通 2豪华*/
                fires_type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**1普通 2豪华*/
            fires_type: number
        ];
        recv: {
            /** 错误码(收到1 放烟花) */
            code: number;
            error_code_args: string;
            /** 1普通 2豪华 */
            fires_type: number;
            /** 发烟花的玩家id */
            role_id: number;
        };
    };
    17270: {
        desc: "发弹幕";
        send: (
            number: 17270,
            fmt: "si",
            args: [
                /** 数据(客户端的坐标,道具展示,伙伴展示,个性化聊天规则由客户端定义)*/
                msg: string,
                /**玩家登陆秒数*/
                tk_time: number
            ]
        ) => never;
        sendFmt: "si";
        sendArgs: [
            /** 数据(客户端的坐标,道具展示,伙伴展示,个性化聊天规则由客户端定义)*/
            msg: string,
            /**玩家登陆秒数*/
            tk_time: number
        ];
        recv: {
            /** 错误码 */
            code: number;
        };
    };
    17271: {
        desc: "采集喜宴/喜糖";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
            error_code_args: string;
            /** 类型 1喜宴 2普通喜糖 3豪华喜糖 */
            type: number;
        };
    };
    17272: {
        desc: "婚礼玩家个人信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
            /** 是否结婚玩家 0否 1是 */
            if_master: number;
            /** 当前剩余免费发糖果次数（非结婚玩家不显示） */
            free_candies: number;
            /** 当前剩余免费放烟花次数 */
            free_fires: number;
            /** 已收集的餐桌怪物唯一id列表 */
            collect_table_list: {
                table_mon_only_id: number;
            }[];
        };
    };
    17273: {
        desc: "提示婚礼结束（发送给婚礼结束时在婚礼场景的玩家）";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
        };
    };
    17274: {
        desc: "通知捣蛋鬼出现/消失暂时不用";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1出现 0消失 */
            type: number;
        };
    };
    17275: {
        desc: "婚礼获得总经验";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 总经验 */
            all_exp: number;
        };
    };
    17276: {
        desc: "告诉主办婚礼玩家婚礼结束（只发给新人）";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            role_id_m: number;
            role_id_w: number;
        };
    };
    17277: {
        desc: "信息推送";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            info_list: {
                /** 1 气氛值 */
                type: number;
                /** 值 */
                values: number;
            }[];
        };
    };
    17278: {
        desc: "气氛值奖励";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            aura_num: number;
            reward: any;
        };
    };
    17279: {
        desc: "采集奖励";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 类型 1喜宴 2普通喜糖 3豪华喜糖 */
            type: number;
            reward: any;
        };
    };
    17280: {
        desc: "宝宝是否激活";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
            /** 是否激活 0否 1是 */
            if_active: number;
            image_active_list: {
                image_id: number;
                /** 是否激活 0否 1是 */
                if_active: number;
            }[];
        };
    };
    17281: {
        desc: "激活宝宝";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
        };
    };
    17282: {
        desc: "打开宝宝学识界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
            /** 阶数 */
            stage: number;
            /** 星数 */
            star: number;
            /** 祝福值 */
            pray_num: number;
            /** 戒指战力 */
            baby_combat_power: number;
        };
    };
    17283: {
        desc: "培养宝宝学识";
        send: (
            number: 17283,
            fmt: "i",
            args: [
                /**物品类型id*/
                goods_type_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**物品类型id*/
            goods_type_id: number
        ];
        recv: {
            /** 错误码 */
            code: number;
            /** 新阶数 */
            new_stage: number;
            /** 新星数 */
            new_star: number;
            /** 新祝福值 */
            new_pray_num: number;
        };
    };
    17284: {
        desc: "一键培养宝宝学识";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
            /** 新阶数 */
            new_stage: number;
            /** 新星数 */
            new_star: number;
            /** 新祝福值 */
            new_pray_num: number;
        };
    };
    17285: {
        desc: "打开宝宝资质界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
            /** 等级 */
            aptitude_lv: number;
            /** 戒指战力 */
            baby_combat_power: number;
        };
    };
    17286: {
        desc: "培养宝宝资质";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
        };
    };
    17287: {
        desc: "打开宝宝幻形";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
            image_list: {
                /** 幻形id */
                image_id: number;
                /** 是否激活 0否 1是 */
                if_active: number;
                /** 阶数 */
                stage: number;
                /** 祝福值 */
                pray_num: number;
                /** 宝宝幻形战力 */
                image_combat_power: number;
            }[];
        };
    };
    17288: {
        desc: "激活宝宝幻形";
        send: (
            number: 17288,
            fmt: "c",
            args: [
                /**幻形id*/
                image_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**幻形id*/
            image_id: number
        ];
        recv: {
            /** 错误码 */
            code: number;
            /** 幻形id */
            image_id: number;
        };
    };
    17289: {
        desc: "培养宝宝幻形";
        send: (
            number: 17289,
            fmt: "ci",
            args: [
                /**幻形id*/
                image_id: number,
                /**物品类型id*/
                goods_type_id: number
            ]
        ) => never;
        sendFmt: "ci";
        sendArgs: [
            /**幻形id*/
            image_id: number,
            /**物品类型id*/
            goods_type_id: number
        ];
        recv: {
            /** 错误码 */
            code: number;
            /** 幻形id */
            image_id: number;
            /** 新阶数 */
            new_stage: number;
            /** 新祝福值 */
            new_pray_num: number;
        };
    };
    17290: {
        desc: "一键培养宝宝幻形";
        send: (
            number: 17290,
            fmt: "c",
            args: [
                /**幻形id*/
                image_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**幻形id*/
            image_id: number
        ];
        recv: {
            /** 错误码 */
            code: number;
            /** 幻形id */
            image_id: number;
            /** 新阶数 */
            new_stage: number;
            /** 新祝福值 */
            new_pray_num: number;
        };
    };
    17291: {
        desc: "改变宝宝形象（非幻形）";
        send: (
            number: 17291,
            fmt: "c",
            args: [
                /**阶数id*/
                chage_stage: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**阶数id*/
            chage_stage: number
        ];
        recv: {
            /** 错误码 */
            code: number;
        };
    };
    17292: {
        desc: "改变宝宝形象（幻形）";
        send: (
            number: 17292,
            fmt: "c",
            args: [
                /**形象id*/
                image_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**形象id*/
            image_id: number
        ];
        recv: {
            /** 错误码 */
            code: number;
        };
    };
    17293: {
        desc: "显示/隐藏宝宝形象";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
            /** 宝宝形象id */
            baby_id: number;
            /** 宝宝形象是否显示（0不显示 1显示） */
            baby_if_show: number;
        };
    };
    17294: {
        desc: "通知整个场馆的人宝宝形象变化";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家id */
            role_id: number;
            /** 宝宝形象id */
            baby_id: number;
            /** 宝宝形象是否显示（0不显示 1显示） */
            baby_if_show: number;
        };
    };
    17295: {
        desc: "邀请伴侣购买副本次数";
        send: (number: 17295, fmt: "i", args: [dun_id: number]) => never;
        sendFmt: "i";
        sendArgs: [dun_id: number];
        recv: {
            /** 1 请求成功 2  其他读错误码配置 */
            code: number;
        };
    };
    17296: {
        desc: "邀请购买副本次数信息推送";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            role_id: number;
            role_name: string;
            dun_id: number;
        };
    };
    17297: {
        desc: "同意购买/不同意购买";
        send: (
            number: 17297,
            fmt: "ci",
            args: [
                /**1 同意 2 拒绝*/
                agree: number,
                dun_id: number
            ]
        ) => never;
        sendFmt: "ci";
        sendArgs: [
            /**1 同意 2 拒绝*/
            agree: number,
            dun_id: number
        ];
        recv: {
            /** 1 同意 2 拒绝 */
            agree: number;
            dun_id: number;
            role_id: number;
            role_name: string;
        };
    };
    17298: {
        desc: "一健邀请功能";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            error_code: number;
        };
    };
}
