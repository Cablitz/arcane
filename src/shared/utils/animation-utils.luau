local exports = {}

function exports.loadAnimation(animator: Animator, animationId: number)
	local animation = Instance.new("Animation")
	animation.AnimationId = "rbxassetid://" .. animationId

	return animator:LoadAnimation(animation)
end

return exports
