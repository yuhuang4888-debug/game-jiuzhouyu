import { BaseWindowComponent } from '../common/BaseWindowComponent';
import { EventName } from '../common/EventName';
import { InstructionType } from '../common/InstructionType';
import { GuildModel, GuildEvent } from '../commonModel/GuildModel';
import { ServerTimeModel } from '../serverTime/ServerTimeModel';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { RedPacketModel } from '../commonModel/RedPacketModel';
import { HolyTerritoryModel } from '../commonModel/HolyTerritoryModel';
import { ShopEvent, ShopModel } from '../commonModel/ShopModel';

import './GuildMainView';
import './GuildMemberView';
import './GuildRewardBoxView';
import './GuildJoinView';
import { RedKey } from '../common/RedDotDefine';
export class GuildMainBaseView extends BaseWindowComponent {
    box_index = 3;
    dependent_res = ['guild'];
    destroy_imm = true;
    titleStr = 'guild.guild_001';
    money_list = [2, 1, 0];
    instruction_list = [InstructionType.Guild];
    public constructor() {
        super();
    }

    public BaseWindowCloseFunc() {
        let openHolyTerritoryView = false;
        if (this.nowSelectIndex == 2) {
            openHolyTerritoryView = true;
        }
        if(this.story_model.task_supplement_list["GuildDonateTaskId"]){
            delete this.story_model.task_supplement_list["GuildDonateTaskId"]
        }
        super.BaseWindowCloseFunc();
        // if (openHolyTerritoryView && HolyTerritoryModel.BackIndex) {
        // 	HolyTerritoryModel.GetInstance().Fire(HTEvent.OPEN_VIEW, "holyTerritoryMainView", HolyTerritoryModel.BackIndex)
        // }
        // HolyTerritoryModel.BackIndex = null
    }

    public Open(...new_args) {
        let parm = new_args[0];
        if (parm) {
            this.SetDefaultIndex(parm[0]);
            this.SetIndexParameter(parm[0], parm[1]);
        }
        if (ServerTimeModel.GetInstance().GetOpenServerDay() <= HolyTerritoryModel.GetInstance().maxDay) {
            this.box_index = 3;
            this.bg_list = ['ui_Guild_bg.jpg', 'daily_bg.jpg', 'ui_Guild_bg4.jpg', 'daily_bg.jpg', 'daily_bg.jpg'];
            this.viewClassList = ['GuildMainView', 'GuildMemberView', 'HolyTerritoryGuildView', 'GuildRewardBoxView'];
            this.tabStrList = [
                { label: '信息', icon_up_source: 'guild_asset.guild_022', icon_down_source: 'guild_asset.guild_021', red_key: RedKey.GUILD_INFO },
                { label: '成员', icon_up_source: 'guild_asset.guild_024', icon_down_source: 'guild_asset.guild_023', red_key: RedKey.GUILD_MEMBER },
                { label: '排行', open_lv: 95, icon_up_source: 'guild_asset.guild_024', icon_down_source: 'guild_asset.guild_023' },
                { label: '宝箱', icon_up_source: 'guild_asset.uigh_018_20', icon_down_source: 'guild_asset.uigh_018_19', red_key: RedKey.GUILD_REWARD_BOX }
            ];
            //this.viewClassModuleDic = [{module_name="guild", class_name="GuildMainView"], [1]=[module_name="guild", class_name="GuildMemberView"], [2]=[module_name="holyTerritory", class_name="HolyTerritoryGuildView"], [3]=[module_name="guild", class_name="GuildRewardBoxView"], [4]=[module_name="guild", class_name="GuildJoinView"]]
        } else {
            this.box_index = 2;
            this.bg_list = ['ui_Guild_bg.jpg', 'daily_bg.jpg', 'daily_bg.jpg', 'daily_bg.jpg'];
            this.viewClassList = ['GuildMainView', 'GuildMemberView', 'GuildRewardBoxView', 'GuildJoinView'];
            this.tabStrList = [
                { label: '信息', icon_up_source: 'guild_asset.guild_022', icon_down_source: 'guild_asset.guild_021', red_key: RedKey.GUILD_INFO },
                { label: '成员', icon_up_source: 'guild_asset.guild_024', icon_down_source: 'guild_asset.guild_023', red_key: RedKey.GUILD_MEMBER },
                { label: '宝箱', icon_up_source: 'guild_asset.uigh_018_20', icon_down_source: 'guild_asset.uigh_018_19', red_key: RedKey.GUILD_REWARD_BOX },
                { label: '其他', icon_up_source: 'guild_asset.uigh_018_26', icon_down_source: 'guild_asset.uigh_018_25' }
            ];
            //this.viewClassModuleDic = [{module_name="guild", class_name="GuildMainView"], [1]=[module_name="guild", class_name="GuildMemberView"], [2]=[module_name="guild", class_name="GuildRewardBoxView"], [3]=[module_name="guild", class_name="GuildJoinView"]]
        }

        super.Open();
    }

    public DeleteMe() {
        super.DeleteMe();
    }




}
window['GuildMainBaseView'] = GuildMainBaseView;
