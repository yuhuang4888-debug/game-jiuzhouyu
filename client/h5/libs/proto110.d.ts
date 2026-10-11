/** 聊天信息
 */
declare interface ProtoFmtInfo {
    11000: {
        desc: "错误码";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            error_code: number;
            /**  参数 */
            args: string;
        };
    };
    11001: {
        desc: "通用文字聊天";
        send: (
            number: 11001,
            fmt: "csslssis",
            args: [
                /**频道*/
                channel: number,
                /** 发言者所在省份*/
                province: string,
                /** 发言者所在城市*/
                city: string,
                /**接受者id 当为喇叭频道时 1本服 2小跨服 3大跨服*/
                receive_id: number,
                /** 数据(客户端的坐标,道具展示,伙伴展示,个性化聊天规则由客户端定义)*/
                msg: string,
                /** 参数(用于校验以及参数展示)*/
                args: string,
                /**玩家登陆秒数*/
                tk_time: number,
                /** 加密字符*/
                ticket: string
            ]
        ) => never;
        sendFmt: "csslssis";
        sendArgs: [
            /**频道*/
            channel: number,
            /** 发言者所在省份*/
            province: string,
            /** 发言者所在城市*/
            city: string,
            /**接受者id 当为喇叭频道时 1本服 2小跨服 3大跨服*/
            receive_id: number,
            /** 数据(客户端的坐标,道具展示,伙伴展示,个性化聊天规则由客户端定义)*/
            msg: string,
            /** 参数(用于校验以及参数展示)*/
            args: string,
            /**玩家登陆秒数*/
            tk_time: number,
            /** 加密字符*/
            ticket: string
        ];
        recv: {
            /** 频道 */
            channel: number;
            /** 发送者服数 */
            server_num: number;
            /**  发送者服信息 */
            c_server_msg: string;
            /** 发送者服务器id */
            ser_id: number;
            /**  发送者服务器名称 只有跨服聊天频道才显示 */
            ser_name: string;
            /**  发言者所在省份 */
            province: string;
            /**  发言者所在城市 */
            city: string;
            /** 玩家id */
            player_id: number;
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
            /**  数据 */
            msg: string;
            /**  参数 \[{Key, Value}, {Key, Value1, Value2}]\ */
            args: string;
            /** 参数校验结果 0:无参数 1:有参数校验正常 2:有参数校验失败 */
            result: number;
            /** 服务器时间戳 */
            time: number;
        };
    };
    11002: {
        desc: "通用文字私聊";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 频道 */
            channel: number;
            /** 发送者服数 */
            server_num: number;
            /** 发送者服务器id */
            ser_id: number;
            /**  发送者服务器名称 只有跨服聊天频道才显示 */
            ser_name: string;
            /** 一定是两个玩家 第一个是发送者,第二个是接受者 */
            player_list: {
                /** 玩家id */
                player_id: number;
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
            /**  数据 */
            msg: string;
            /**  参数 \[{Key, Value}, {Key, Value1, Value2}]\ */
            args: string;
            /** 参数校验结果 0:无参数 1:有参数校验正常 2:有参数校验失败 */
            result: number;
            /** 服务器时间戳 */
            time: number;
        };
    };
    11003: {
        desc: "发送语音和语音文字信息";
        send: (
            number: 11003,
            fmt: "cliisislc",
            args: [
                /**频道*/
                channel: number,
                /**接受者id*/
                receive_id: number,
                /**语音时间(秒)*/
                voice_msg_time: number,
                /**时间戳*/
                tk_time: number,
                /** 加密字符*/
                ticket: string,
                /**语音内容*/
                data_send: number,
                /** 语音文字内容*/
                voice_text: string,
                /**自增id*/
                auto_id: number,
                /**是否完成语音信息发送（1：完成，2：未完成）CMD11012返回1后继续发送语音剩余部分*/
                is_end: number
            ]
        ) => never;
        sendFmt: "cliisislc";
        sendArgs: [
            /**频道*/
            channel: number,
            /**接受者id*/
            receive_id: number,
            /**语音时间(秒)*/
            voice_msg_time: number,
            /**时间戳*/
            tk_time: number,
            /** 加密字符*/
            ticket: string,
            /**语音内容*/
            data_send: number,
            /** 语音文字内容*/
            voice_text: string,
            /**自增id*/
            auto_id: number,
            /**是否完成语音信息发送（1：完成，2：未完成）CMD11012返回1后继续发送语音剩余部分*/
            is_end: number
        ];
        recv: {
            /** 频道 */
            channel: number;
            /** 发送者服数 */
            server_num: number;
            /** 发送者服务器id */
            ser_id: number;
            /**  发送者服务器名称 只有跨服聊天频道才显示 */
            ser_name: string;
            /** 一定是两个玩家 第一个是发送者,第二个是接受者(如果接收者id为0且是私聊,则只有一个数据) */
            player_list: {
                /** 玩家id */
                player_id: number;
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
            /** 玩家的客户端版本号 */
            client_ver: number;
            /** 自增id */
            auto_id: number;
            /** 接受者id */
            receive_id: number;
            /**  语音文字内容 */
            voice_text: string;
            /** 语音时间(秒) */
            voice_msg_time: number;
            /** 服务器时间戳 */
            time: number;
        };
    };
    11004: {
        desc: "获取语音信息";
        send: (
            number: 11004,
            fmt: "llis",
            args: [
                /**自增id*/
                auto_id: number,
                /**语音信息发送者id*/
                player_id: number,
                /**unix时间戳*/
                tk_time: number,
                /** 加密字符*/
                ticket: string
            ]
        ) => never;
        sendFmt: "llis";
        sendArgs: [
            /**自增id*/
            auto_id: number,
            /**语音信息发送者id*/
            player_id: number,
            /**unix时间戳*/
            tk_time: number,
            /** 加密字符*/
            ticket: string
        ];
        recv: {
            /** 错误码 */
            error_code: number;
            /** 自增id */
            auto_id: number;
            /** 语音内容 */
            data_send: number;
        };
    };
    11005: {
        desc: "上传语音翻译文字信息";
        send: (
            number: 11005,
            fmt: "clls",
            args: [
                /**频道*/
                channel: number,
                /**接受者id*/
                receive_id: number,
                /**自增id*/
                auto_id: number,
                /** 语音文字内容*/
                voice_text: string
            ]
        ) => never;
        sendFmt: "clls";
        sendArgs: [
            /**频道*/
            channel: number,
            /**接受者id*/
            receive_id: number,
            /**自增id*/
            auto_id: number,
            /** 语音文字内容*/
            voice_text: string
        ];
        recv: {
            /** 错误码 */
            error_code: number;
        };
    };
    11006: {
        desc: "获取语音文字信息";
        send: (
            number: 11006,
            fmt: "ll",
            args: [
                /**自增id*/
                auto_id: number,
                /**语音信息发送者id*/
                player_id: number
            ]
        ) => never;
        sendFmt: "ll";
        sendArgs: [
            /**自增id*/
            auto_id: number,
            /**语音信息发送者id*/
            player_id: number
        ];
        recv: {
            /** 错误码 */
            error_code: number;
            /** 自增id */
            auto_id: number;
            /**  语音文字内容 */
            voice_text: string;
        };
    };
    11007: {
        desc: "图片信息";
        send: (
            number: 11007,
            fmt: "clcisss",
            args: [
                /**频道*/
                channel: number,
                /**接受者id*/
                preceive_id: number,
                /**是否全部上传完毕(1:完毕, 0:图片被分割，后面还有一部分)*/
                is_end: number,
                /**unix时间戳*/
                tk_time: number,
                /** 加密字符*/
                ticket: string,
                /** 缩略图片数据*/
                tiny_picture: string,
                /** 真实图片数据*/
                real_picture: string
            ]
        ) => never;
        sendFmt: "clcisss";
        sendArgs: [
            /**频道*/
            channel: number,
            /**接受者id*/
            preceive_id: number,
            /**是否全部上传完毕(1:完毕, 0:图片被分割，后面还有一部分)*/
            is_end: number,
            /**unix时间戳*/
            tk_time: number,
            /** 加密字符*/
            ticket: string,
            /** 缩略图片数据*/
            tiny_picture: string,
            /** 真实图片数据*/
            real_picture: string
        ];
        recv: {
            /** 频道 */
            channel: number;
            /** 玩家id */
            player_id: number;
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
            /** 自增id */
            auto_id: number;
            /** 私聊目标id */
            receive_id: number;
            /**  缩略图片数据 */
            tiny_picture: string;
        };
    };
    11008: {
        desc: "获取图片信息";
        send: (
            number: 11008,
            fmt: "lis",
            args: [
                /**自增id*/
                auto_id: number,
                /**unix时间戳*/
                tk_time: number,
                /** 加密字符*/
                ticket: string
            ]
        ) => never;
        sendFmt: "lis";
        sendArgs: [
            /**自增id*/
            auto_id: number,
            /**unix时间戳*/
            tk_time: number,
            /** 加密字符*/
            ticket: string
        ];
        recv: {
            /** 自增id */
            auto_id: number;
            /**  完整的图片信息 */
            picture: string;
        };
    };
    11009: {
        desc: "告诉客户端图片部分上传成功";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 0:失败 1:成功 */
            error_code: number;
        };
    };
    11010: {
        desc: "聊天缓存";
        send: (
            number: 11010,
            fmt: "c",
            args: [
                /**频道*/
                channel: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**频道*/
            channel: number
        ];
        recv: {
            cache_list: {
                /** 频道 */
                channel: number;
                /** 一定是两个玩家 第一个是发送者,第二个是接受者 */
                player_list: {
                    /** 发送者服数 */
                    server_num: number;
                    /**  发送者服信息 */
                    c_server_msg: string;
                    /** 发送者服务器id */
                    ser_id: number;
                    /**  发送者服务器名称 只有跨服聊天频道才显示 */
                    ser_name: string;
                    /** 玩家id */
                    player_id: number;
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
                /**  数据文字语音文字内容 */
                msg: string;
                /**  参数 \[{Key, Value}, {Key, Value1, Value2}]\ */
                args: string;
                /** 参数校验结果 0:无参数 1:有参数校验正常 2:有参数校验失败 */
                result: number;
                /** 服务器时间戳 */
                time: number;
                /** 是否已读##0:未读;1:已读 */
                is_read: number;
                /** 语音自增id##大于0则是语音 */
                voice_id: number;
                /** 语音时间(秒) */
                voice_time: number;
            }[];
        };
    };
    11011: {
        desc: "世界聊天的次数";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 世界聊天的免费次数 */
            count: number;
        };
    };
    11012: {
        desc: "告诉客户端语音分部上传成功";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0:失败;1:成功 */
            error_code: number;
        };
    };
    11013: {
        desc: "广播语音文字";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 频道 */
            channel: number;
            /** 自增id */
            auto_id: number;
            /**  语音文字内容 */
            voice_text: string;
        };
    };
    11014: {
        desc: "发言过频通知";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    11015: {
        desc: "系统动态消息处理传闻、普通消息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 模块id */
            module_id: number;
            /** 配置id */
            id: number;
            /**  内容 （需要对它进行特殊匹配，含有规则匹配） */
            content: string;
        };
    };
    11016: {
        desc: "小红点处理通用小红点,写一些特殊的小红点由客户端请求对应功能的协议";
        send: (
            number: 11016,
            fmt: "hh",
            args: [
                /**模块id*/
                module_id: number,
                /**类型(根据功能自定义,服务端描述在chat.hrl中)*/
                type: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**模块id*/
            module_id: number,
            /**类型(根据功能自定义,服务端描述在chat.hrl中)*/
            type: number
        ];
        recv: {
            /** 模块id */
            module_id: number;
            /** 类型 */
            type: number;
            /** 数量 */
            num: number;
        };
    };
    11017: {
        desc: "聊天频道的错误码消息目前暂时只有队伍频道,后续需要加频道的话,加一个字段";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1只飘字  2只聊天框  3飘字加聊天框(队伍频道) */
            type: number;
            /** 错误码 */
            error_code: number;
            /**  错误码参数 */
            error_code_args: string;
        };
    };
    11018: {
        desc: "玩家动态消息处理传闻、普通消息处理同11015";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 发送者服务器id */
            ser_id: number;
            /** 玩家id */
            player_id: number;
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
            /** 模块id */
            module_id: number;
            /** 配置id */
            id: number;
            /**  内容 （需要对它进行特殊匹配，含有规则匹配） */
            content: string;
        };
    };
    11019: {
        desc: "动态消息2处理传闻、普通消息处理同11015";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 模块id */
            module_id: number;
            /** 配置id */
            id: number;
            content_list: {
                /**  内容 （需要对它进行特殊匹配，含有规则匹配） */
                content: string;
            }[];
        };
    };
    11020: {
        desc: "系统信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /**  右下角提示 */
            content: string;
        };
    };
    11021: {
        desc: "GM系统喇叭";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 喇叭 */
            channel: number;
            /** gm=1 */
            gm: number;
            /** 显示多少秒 */
            time: number;
            /**  显示内容 */
            msg: string;
        };
    };
    11022: {
        desc: "帮派求助";
        send: (
            number: 11022,
            fmt: "cls",
            args: [
                /**boss类型*/
                boss_type: number,
                /**杀人玩家id*/
                kill_id: number,
                /** 杀人玩家名字*/
                kill_name: string
            ]
        ) => never;
        sendFmt: "cls";
        sendArgs: [
            /**boss类型*/
            boss_type: number,
            /**杀人玩家id*/
            kill_id: number,
            /** 杀人玩家名字*/
            kill_name: string
        ];
        recv: null;
    };
    11023: {
        desc: "是否开启小跨服聊天";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 是否开启跨服 */
            is_open: number;
        };
    };
    11024: {
        desc: "是否开启小跨服聊天(幻兽区域版)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 是否开启跨服  0 未开启 1 开启 2 重置中 */
            is_open: number;
        };
    };
    11025: {
        desc: "上传物品数据到跨服";
        send: (
            number: 11025,
            fmt: "cA",
            args: [
                /**频道*/
                channel: number,
                id_list: any
            ]
        ) => never;
        sendFmt: "cA";
        sendArgs: [
            /**频道*/
            channel: number,
            id_list: any
        ];
        recv: {
            /** 错误码 */
            error_code: number;
        };
    };
    11026: {
        desc: "跨服查看物品";
        send: (
            number: 11026,
            fmt: "cl",
            args: [
                /**频道*/
                channel: number,
                /**物品id*/
                goods_id: number
            ]
        ) => never;
        sendFmt: "cl";
        sendArgs: [
            /**频道*/
            channel: number,
            /**物品id*/
            goods_id: number
        ];
        recv: {
            /** 错误码 */
            error_code: number;
        };
    };
    11027: {
        desc: "点击聊天缓存消除小红点";
        send: (
            number: 11027,
            fmt: "cl",
            args: [
                /**频道*/
                channel: number,
                /**玩家id*/
                role_id: number
            ]
        ) => never;
        sendFmt: "cl";
        sendArgs: [
            /**频道*/
            channel: number,
            /**玩家id*/
            role_id: number
        ];
        recv: {
            /** 错误码 */
            error_code: number;
        };
    };
    11028: {
        desc: "查看私聊的玩家信息";
        send: (
            number: 11028,
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
            /** 错误码 */
            error_code: number;
            /** 玩家id */
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
            /** 战力 */
            combat_power: number;
            /** 0: 不在线 1: 在线 */
            online_flag: number;
            /** 亲密度 */
            intimacy: number;
        };
    };
    11029: {
        desc: "喇叭返回数据";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 频道 */
            channel: number;
            /** 发送者服数 */
            server_num: number;
            /** 发送者服务器id */
            ser_id: number;
            /**  发送者服务器名称 只有跨服聊天频道才显示 */
            ser_name: string;
            /**  发言者所在省份 */
            province: string;
            /**  发言者所在城市 */
            city: string;
            /** 喇叭类型  1本服 2小跨服 3大跨服 */
            horn_type: number;
            /** 玩家id */
            player_id: number;
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
            /**  数据 */
            msg: string;
            /**  参数 \[{Key, Value}, {Key, Value1, Value2}]\ */
            args: string;
            /** 参数校验结果 0:无参数 1:有参数校验正常 2:有参数校验失败 */
            result: number;
            /** 服务器时间戳 */
            time: number;
        };
    };
    11040: {
        desc: "GM禁言";
        send: (
            number: 11040,
            fmt: "lc",
            args: [
                /**玩家id*/
                uid: number,
                /**禁言时长*/
                limit_time: number
            ]
        ) => never;
        sendFmt: "lc";
        sendArgs: [
            /**玩家id*/
            uid: number,
            /**禁言时长*/
            limit_time: number
        ];
        recv: {
            /** 错误码 0:禁言失败;1:禁言成功;2:权限不够 */
            result: number;
        };
    };
    11041: {
        desc: "GM解禁言";
        send: (
            number: 11041,
            fmt: "l",
            args: [
                /**玩家id*/
                uid: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**玩家id*/
            uid: number
        ];
        recv: {
            /** 错误码 0:解禁言失败;1:解禁言成功;2:权限不够 */
            result: number;
        };
    };
    11042: {
        desc: "被禁言通知";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 距离禁言解除时间(秒) */
            result: number;
        };
    };
    11043: {
        desc: "获取禁言信息";
        send: (
            number: 11043,
            fmt: "l",
            args: [
                /**玩家id*/
                uid: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**玩家id*/
            uid: number
        ];
        recv: {
            /** 0:正常 1:被禁言 */
            result: number;
        };
    };
    11044: {
        desc: "聊天举报";
        send: (
            number: 11044,
            fmt: "l",
            args: [
                /**被举报玩家id*/
                target_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**被举报玩家id*/
            target_id: number
        ];
        recv: {
            /** 结果标识 0:失败;1:成功 */
            result: number;
        };
    };
    11045: {
        desc: "聊天举报";
        send: (
            number: 11045,
            fmt: "ls",
            args: [
                /**被举报玩家id*/
                target_id: number,
                /** 被举报的聊天信息*/
                target_data: string
            ]
        ) => never;
        sendFmt: "ls";
        sendArgs: [
            /**被举报玩家id*/
            target_id: number,
            /** 被举报的聊天信息*/
            target_data: string
        ];
        recv: {
            /** 结果标识 0:失败;1:成功;2:你们是好友，不能举报 */
            result: number;
        };
    };
    11046: {
        desc: "通知客户端清理玩家聊天数据";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            list: {
                /** 玩家id */
                role_id: number;
            }[];
        };
    };
    11047: {
        desc: "举报";
        send: (
            number: 11047,
            fmt: "cl",
            args: [
                /**1: 聊天举报 2: 头像举报*/
                type: number,
                /**目标玩家id*/
                target_id: number
            ]
        ) => never;
        sendFmt: "cl";
        sendArgs: [
            /**1: 聊天举报 2: 头像举报*/
            type: number,
            /**目标玩家id*/
            target_id: number
        ];
        recv: {
            /** 错误码 */
            result: number;
            /** 1: 聊天举报 2: 头像举报 */
            type: number;
        };
    };
    11048: {
        desc: "举报成功";
        send: (
            number: 11048,
            fmt: "cl",
            args: [
                /**1: 聊天举报 2: 头像举报*/
                type: number,
                /**目标玩家id*/
                target_id: number
            ]
        ) => never;
        sendFmt: "cl";
        sendArgs: [
            /**1: 聊天举报 2: 头像举报*/
            type: number,
            /**目标玩家id*/
            target_id: number
        ];
        recv: {
            /** 错误码 */
            result: number;
        };
    };
    11050: {
        desc: "系统公告";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            notice_list: {
                /**  渠道 */
                source: string;
                /** 公告类型 */
                type: number;
                /**  颜色 */
                color: string;
                /**  内容 */
                content: string;
                /**  链接 */
                url: string;
                /** 发送次数 */
                send_count: number;
                /** 发送间隔 */
                send_gap: number;
                /** 开始时间 */
                start_time: number;
                /** 结束时间 */
                end_time: number;
                /** 状态 */
                state: number;
            }[];
        };
    };
    11060: {
        desc: "获得物品显示信息在右下角提示框内";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1 右下角飘字 2 聊天框系统提示 3 右下角飘字+聊天框  4 掉落特效 */
            type: number;
            goods_list: {
                /** 物品类型id */
                goods_type_id: number;
                /** 数量 */
                num: number;
            }[];
        };
    };
    11061: {
        desc: "获得物品显示信息在右下角提示框内";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            object_list: any;
        };
    };
    11062: {
        desc: "系统动态消息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 语言id */
            language_id: number;
            args_list: {
                /** 	参数 */
                args: string;
            }[];
        };
    };
    11063: {
        desc: "在屏幕显示特定特效";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /**  特效名称 */
            effect: string;
        };
    };
    11064: {
        desc: "假人聊天触发";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 类型 */
            type: number;
        };
    };
    11065: {
        desc: "聊天监控动态包编号";
        send: (
            number: 11065,
            fmt: "s",
            args: [
                /** 动态包编号*/
                package_code: string
            ]
        ) => never;
        sendFmt: "s";
        sendArgs: [
            /** 动态包编号*/
            package_code: string
        ];
        recv: {
            /** 返回码 */
            code: number;
        };
    };
}
