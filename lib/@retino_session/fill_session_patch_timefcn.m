function obj = fill_session_patch_timefcn(obj)
	for i_patch = 1:length(obj.a_patch)
		ai_patch = obj.a_patch(i_patch);
		Fall = [];
		Vall = [];
		for i_source = 1:length(obj.a_source)
			ai_source = obj.a_source(i_source);
			t.rp = obj.retinoPatch(ai_source, ai_patch);
			t.F = t.rp.F.mean.norm;
			Fall = [Fall t.F(obj.a_chan)];
			Vall = obj.concat_V_kern(t.rp);
		end
		thisPatch.timefcn = Fall\Vall;
		for i_source = obj.a_source
			ai_source = obj.a_source(i_source);
			t.rp = obj.retinoPatch(ai_source, ai_patch);
			t.rp.timefcn = thisPatch.timefcn(i_source,:);
		end
	end
end
