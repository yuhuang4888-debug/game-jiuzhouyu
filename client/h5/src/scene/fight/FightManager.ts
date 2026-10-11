import { EventDispatcher } from "../../util/EventDispatcher";
import { BuffVo } from "./BuffVo";
import { BuffListVo } from "./BuffListVo";
import { SceneBaseType } from "../SceneConfig";
import { Status } from "../../util/Status";
import { FightMovieInfo } from "./FightMovieInfo";
import { FightVo } from "./FightVo";
// TypeScript file
let local_Status = Status
let local_SceneBaseType = SceneBaseType
export class FightManager extends EventDispatcher {
	static Instance: FightManager;
	buffVo_pool: Array<BuffVo> = [];
	buffVo_list_pool: Array<BuffListVo> = [];
	particle_tar_pool: Array<any> = [];
	particle_pos_pool: Array<any> = [];
	fightVo_pool:FightVo[] = []; // fightvo的对象池
	fightMovie_pool:FightMovieInfo[] = []; //FightMovieInfo的对象池
	request_fight_info_pool = []; //发起攻击的对象池
	bullet_pool = [];
	hiter_list = {};
	damage_info_pool = [];


	curr_hiter_num = 0;
	game_active_time = null; //切回游戏的开始时间
	collect_monster_type_id
	collect_monster_ins_id
	public constructor() {
		super();
		for (let i = 0; i < 6; i++) {
			this.damage_info_pool[i] = []; //伤害数据对象池
		}
	}
	public static GetInstance() {
		if (!FightManager.Instance) {
			FightManager.Instance = new FightManager();
		}
		return FightManager.Instance;
	}
	public appendHiterInfo = (fight_info, defender, defender_info, attacker, skill_id) => {
		if (this.curr_hiter_num > 100)
			this.playAllHiterAnimation();
		else if (this.curr_hiter_num > 50) {
			let vo;
			for (let i in this.hiter_list) {
				vo = this.hiter_list[i];
				if (vo.attacker.GetType() != local_SceneBaseType.MainRole)
					this.deleteVo(vo.id);
			}
		}
		let vo = this.hiter_list[defender.id];
		if (vo) {
			vo.defender_info = defender_info;
			vo.attacker = attacker;
			vo.skill_id = skill_id;
			vo.defender = defender;
			vo.fight_info = fight_info;
		}
		else {
			vo = {
				time: local_Status.NowTime,
				defender: defender,
				fight_info: fight_info,
				id: defender.id,
				defender_info: defender_info,
				attacker: attacker,
				skill_id: skill_id
			};
			this.appendVo(vo);
		}
	};
	public playHiterAnimantion = () => {
		if (this.curr_hiter_num <= 0)
			return;
		let min_id = null;
		let min_time = 1000000;
		let vo;
		for (let i in this.hiter_list) {
			vo = this.hiter_list[i];
			if (vo.time < min_time) {
				min_time = vo.time;
				min_id = vo.id;
			}
		}
		if (min_id) {
			vo = this.hiter_list[min_id];
			this.deleteVo(min_id);
			vo.fight_info.executeHitedAnimation(vo.defender, vo.defender_info, vo.attacker, vo.skill_id);
		}
	};
	public playAllHiterAnimation = () => {
		let vo;
		for (let i in this.hiter_list) {
			vo = this.hiter_list[i];
			this.deleteVo(i);
			vo.fight_info.executeHitedAnimation(vo.defender, vo.defender_info, vo.attacker, vo.skill_id);
		}
	};


	public clear = () => {
		let self = this
		self.hiter_list = {}
		self.curr_hiter_num = 0

		// let item = self.fightVo_pool.pop()
		// while (item) {
		// 	item.DeleteMe()
		// 	item = self.fightVo_pool.pop()
		// }
		// item = self.fightMovie_pool.pop()
		// while (item) {
		// 	item.DeleteMe()
		// 	item = self.fightMovie_pool.pop()
		// }
		// item = self.buffVo_list_pool.pop()
		// while (item) {
		// 	item.DeleteMe()
		// 	item = self.buffVo_list_pool.pop()
		// }
		// item = self.buffVo_pool.pop()
		// while (item) {
		// 	item.DeleteMe()
		// 	item = self.buffVo_pool.pop()
		// }
		// item = self.particle_pos_pool.pop()
		// while (item) {
		// 	item.DeleteMe()
		// 	item = self.particle_pos_pool.pop()
		// }
		// item = self.particle_tar_pool.pop()
		// while (item) {
		// 	item.DeleteMe()
		// 	item = self.particle_tar_pool.pop()
		// }
		// self.fightVo_pool.length = 0
		// self.fightMovie_pool.length = 0
		// self.buffVo_list_pool.length = 0
		// self.buffVo_pool.length = 0
		// self.particle_pos_pool.length = 0
		// self.particle_tar_pool.length = 0
	}


	public appendVo = (vo) => {
		this.hiter_list[vo.id] = vo;
		this.curr_hiter_num = this.curr_hiter_num + 1;
	};
	public deleteVo = (id) => {
		if (this.hiter_list[id]) {
			delete this.hiter_list[id];
			this.curr_hiter_num = this.curr_hiter_num - 1;
		}
	};

	public pushFightVo = (fightVo:FightVo) => {
		if (fightVo) {
			if (this.fightVo_pool.length < 30) {
				fightVo.resetData();
				this.fightVo_pool.push(fightVo);
			}
			else{
				// fightVo.DeleteMe()
			}
		}
	};
	public pushFightMovie = (fightMovie:FightMovieInfo) => {
		if (fightMovie) {
			if (this.fightMovie_pool.length < 40) {
				fightMovie.resetData();
				this.fightMovie_pool.push(fightMovie);
			}
			else{
				fightMovie.DeleteMe()
			}
		}
	};
	public pushFightInfoList = (fight_info) => {
		if (fight_info) {
			if (this.request_fight_info_pool.length < 15){
				this.request_fight_info_pool.push(fight_info);
			}
			else{
				// fight_info = null;
			}
		}
	};
	public pushBuffVo = (buffVo) => {
		if (buffVo) {
			if (this.buffVo_pool.length < 40) {
				buffVo.resetData();
				this.buffVo_pool.push(buffVo);
			}
			else{
				buffVo.DeleteMe()
			}
		}
	};
	public pushBuffVoList = (buffListVo) => {
		if (buffListVo) {
			if (this.buffVo_list_pool.length < 40) {
				buffListVo.resetData();
				this.buffVo_list_pool.push(buffListVo);
			}
			else
			{
				buffListVo.DeleteMe()
			}
		}
	};
	public pushPosParticleVo = (particle_vo) => {
		if (particle_vo) {
			if (this.particle_pos_pool.length < 15) {
				particle_vo.resetData();
				this.particle_pos_pool.push(particle_vo);
			}
			else{
				particle_vo.DeleteMe();
			}
		}
	};
	public pushTarParticleVo = (particle_vo) => {
		if (particle_vo) {
			if (this.particle_tar_pool.length < 15) {
				particle_vo.resetData();
				this.particle_tar_pool.push(particle_vo);
			}
			else{
				particle_vo.DeleteMe();	
			}
		}
	};
	public pushBullet = (bullet) => {
		if (bullet) {
			if (this.bullet_pool.length < 10) {
				bullet.resetData();
				this.bullet_pool.push(bullet);
			}
			else{
				bullet.DeleteMe();
			}
		}
	};
}

window["FightManager"] = FightManager